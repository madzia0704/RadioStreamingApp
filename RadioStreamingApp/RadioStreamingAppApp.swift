//
//  RadioStreamingApp.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//
import SwiftUI
import Combine

@main
struct RadioStreamingApp: App {
    @StateObject private var favorites = FavoritesManager()
    @StateObject private var stationListViewModel = StationListViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    StationListView(viewModel: stationListViewModel, favorites: favorites)
                }
                .tabItem {
                    Label("Stacje", systemImage: "dot.radiowaves.left.and.right")
                }

                NavigationStack {
                    FavoritesView(
                        favorites: favorites,
                        stationsPublisher: stationListViewModel.stationsPublisher
                    )
                }
                .tabItem {
                    Label("Ulubione", systemImage: "heart.fill")
                }
            }
            .onAppear {
                LocalNotificationManager.shared.requestPermission()
                stationListViewModel.loadStationsIfNeeded()
            }
        }
    }
}
