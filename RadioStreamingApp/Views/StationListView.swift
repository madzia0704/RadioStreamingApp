//
//  StationListView.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//
import SwiftUI

struct StationListView: View {
    @ObservedObject var viewModel: StationListViewModel
    @ObservedObject var favorites: FavoritesManager

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Miasto", text: $viewModel.cityFilter)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Toggle("Użyj API", isOn: $viewModel.useAPI)
                               .padding()
                Picker("Kategoria", selection: $viewModel.selectedCategory) {
                    Text("Wszystkie").tag(nil as RadioCategory?)
                    ForEach(RadioCategory.allCases, id: \.self) {
                        Text($0.displayName).tag($0 as RadioCategory?)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(viewModel.filteredStations) { station in
                    NavigationLink(destination: PlayerView(station: station)) {
                        StationRow(station: station, favorites: favorites)
                    }
                }
                .listStyle(.plain)
            }
            .onAppear {
                viewModel.loadStationsIfNeeded()
            }
            .navigationTitle("Stacje Radiowe")
            .searchable(text: $viewModel.searchText, prompt: "Szukaj stacji")
        }
    }
}
