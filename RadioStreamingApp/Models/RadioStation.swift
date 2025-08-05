//
//  RadioStation.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

struct RadioStation: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let frequency: String
    let streamUrl: String
    let category: RadioCategory
    let city: String
    let logoUrl: String?
    
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.frequency == rhs.frequency) && (lhs.streamUrl == rhs.streamUrl) && (lhs.city == rhs.city)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(frequency)
        hasher.combine(streamUrl)
        hasher.combine(city)
    }
}
