//
//  RadioStationFetcher.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 04/08/2025.
//

import Foundation
import Combine

final class RadioStationFetcher: ObservableObject {
    
    // TODO: filter data on backend side
    func fetchPublisher(useAPI: Bool = true, tag: String? = nil, name: String? = nil, city: String? = nil) -> AnyPublisher<[RadioStation], Error> {
        
        if !useAPI {
            return Just(mockStations)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard var components = URLComponents(string: "https://de1.api.radio-browser.info/json/stations/search") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var queryItems: [URLQueryItem] = [
            .init(name: "order", value: "clickcount"),
            .init(name: "reverse", value: "true"),
            .init(name: "hidebroken", value: "true"),
            .init(name: "country", value: "Poland"),
            .init(name: "language", value: "polish"),
            .init(name: "hls", value: "false"),
            .init(name: "codec", value: "MP3")
        ]

        if let tag = tag {
            queryItems.append(.init(name: "tag", value: tag))
        }
        if let name = name {
            queryItems.append(.init(name: "name", value: name))
        }
        if let city = city {
            queryItems.append(.init(name: "state", value: city))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> [RadioBrowserStation] in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }

                return try JSONDecoder().decode([RadioBrowserStation].self, from: result.data)
            }
            .map { apiStations in
                return apiStations
                    .filter { !$0.url_resolved.isEmpty }
                    .map { api in
                        let tags = api.tags.components(separatedBy: ",")
                        let frequency = tags.filter { str in
                            str.lowercased().contains(" fm") || str.lowercased().contains(" am")
                        }
                        return RadioStation(
                            id: api.stationuuid,
                            name: api.name.trimmingCharacters(in: .whitespacesAndNewlines),
                            frequency: !frequency.isEmpty ? frequency.joined(separator: ", ") : "—",
                            streamUrl: api.url_resolved,
                            category: Self.guessCategory(from: api.tags + api.name),
                            city: api.state ?? "Nieznane",
                            logoUrl: api.favicon?.isEmpty == false ? api.favicon : nil,
                        )
                    }
            }
            .eraseToAnyPublisher()
    }

    private static func guessCategory(from tags: String) -> RadioCategory {
        let tagsLower = tags.lowercased()
        if tagsLower.contains("sport") { return .sports }
        if tagsLower.contains("news") || tagsLower.contains("information") { return .news }
        if tagsLower.contains("culture") || tagsLower.contains("talk") { return .culture }
        return .music
    }
}
