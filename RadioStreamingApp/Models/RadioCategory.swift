//
//  RadioCategory.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

enum RadioCategory: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }

    case news = "News"
    case music = "Music"
    case sports = "Sports"
    case culture = "Culture"
    
    var displayName: String {
        switch self {
        case .news: return "Wiadomości"
        case .music: return "Muzyka"
        case .sports: return "Sport"
        case .culture: return "Kultura"
        }
    }
}
