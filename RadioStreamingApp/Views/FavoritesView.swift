//
//  FavoritesView.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//
import SwiftUI
import Combine

struct FavoritesView: View {
    @ObservedObject var favorites: FavoritesManager
    @StateObject private var viewModel: FavoritesViewModel

    // MARK: - Init
    init(
        favorites: FavoritesManager,
        stationsPublisher: AnyPublisher<[RadioStation], Never>
    ) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(
            allStations: stationsPublisher,
            favorites: favorites
        ))
        self.favorites = favorites
    }

    // MARK: - View Body
    var body: some View {
        Group {
            if viewModel.favoriteStations.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(viewModel.favoriteStations) { station in
                        NavigationLink(destination: PlayerView(station: station)) {
                            StationRow(station: station, favorites: favorites)
                        }
                    }
                }
            }
        }
        .navigationTitle("Ulubione")
        .onAppear {
            favorites.load()
        }
    }

    // MARK: - Empty state
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.gray)

            Text("Brak ulubionych stacji")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Dodaj stacje do ulubionych, aby mieć szybki dostęp.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
