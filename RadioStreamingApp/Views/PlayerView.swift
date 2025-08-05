//
//  PlayerView.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

import SwiftUI

struct PlayerView: View {
    let station: RadioStation
    @StateObject private var player = RadioPlayerManager()

    var body: some View {
        VStack(spacing: 24) {
            Text(station.name)
                .font(.largeTitle)
                .bold()
            Text(station.frequency)
                .font(.title2)

            Button(action: {
                player.togglePlayback(for: station)
            }) {
                Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Odtwarzacz")
        .navigationBarTitleDisplayMode(.inline)
    }
}
