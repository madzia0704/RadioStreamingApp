//
//  FavoritesManager.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//
import Foundation
import Combine

final class FavoritesManager: ObservableObject {
    // MARK: - Published properties
    @Published private(set) var favoriteIDs: Set<String> = []
    
    // MARK: - Private properties
    private let storageKey = "FavoriteStationIDs"
    
    // MARK: - Init
    init() {
        load()
    }
    
    // MARK: - Public API
    
    func isFavorite(_ station: RadioStation) -> Bool {
        favoriteIDs.contains(station.id)
    }
    
    func toggleFavorite(_ station: RadioStation) {
        if isFavorite(station) {
            favoriteIDs.remove(station.id)
        } else {
            favoriteIDs.insert(station.id)
        }
        save()
    }
    
    func add(_ station: RadioStation) {
        favoriteIDs.insert(station.id)
        save()
    }
    
    func remove(_ station: RadioStation) {
        favoriteIDs.remove(station.id)
        save()
    }
    
    func load() {
        if let savedIDs = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            favoriteIDs = Set(savedIDs)
        }
    }
    
    // MARK: - Private
    
    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: storageKey)
    }
}
