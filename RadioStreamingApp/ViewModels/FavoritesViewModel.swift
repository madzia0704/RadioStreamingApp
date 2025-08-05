//
//  FavoritesViewModel.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 05/08/2025.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteStations: [RadioStation] = []

    private var cancellables = Set<AnyCancellable>()

    init(
        allStations: AnyPublisher<[RadioStation], Never>,
        favorites: FavoritesManager
    ) {
        allStations
            .combineLatest(favorites.$favoriteIDs)
            .map { stations, favoriteIDs in
                stations.filter { favoriteIDs.contains($0.id) }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$favoriteStations)
    }
}
