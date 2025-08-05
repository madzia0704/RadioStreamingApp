//
//  StationRow.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 05/08/2025.
//

import SwiftUI

struct StationRow: View {
    let station: RadioStation
    @ObservedObject var favorites: FavoritesManager

    var body: some View {
        HStack {
            // Logo stacji
            if let logoUrl = station.logoUrl, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            } else {
                // Placeholder, gdy brak loga
                Color.gray.opacity(0.2)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
            }

            // Informacje tekstowe
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.headline)
                Text("\(station.city) • \(station.frequency)")
                    .font(.subheadline)
            }

            Spacer()

            // Przycisk ulubionych
            Button(action: {
                favorites.toggleFavorite(station)
                LocalNotificationManager.shared.notifyFavorite(station: station, addedToFavoutites: favorites.isFavorite(station))
            }) {
                Image(systemName: favorites.isFavorite(station) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
