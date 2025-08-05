//
//  ContentView.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StationListViewModel()
    @StateObject private var favourites = FavoritesManager()

    var body: some View {
        TabView {
            StationListView(viewModel: viewModel, favorites: favourites)
                .tabItem {
                    Label("Stacje", systemImage: "radio")
                }
        }
    }
}
