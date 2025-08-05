//
//  RadioPlayerManager.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

import SwiftUI
import AVFoundation
import MediaPlayer

final class RadioPlayerManager: ObservableObject {
    @Published var isPlaying = false
    private(set) var player: AVPlayer?
    
    private var currentStation: RadioStation?
    
    init() {
        configureAudioSession()
        setupRemoteTransportControls()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    func play(station: RadioStation) {
        guard let url = URL(string: station.streamUrl) else { return }

        if player == nil || (player?.currentItem?.asset as? AVURLAsset)?.url != url {
            player = AVPlayer(url: url)
        }

        player?.play()
        isPlaying = true
        currentStation = station
        updateNowPlayingInfo(for: station)
    }

    func pause() {
        player?.pause()
        isPlaying = false
        updatePlaybackState()
    }

    func togglePlayback(for station: RadioStation) {
        if isPlaying {
            pause()
        } else {
            play(station: station)
        }
    }

    // MARK: - Lock Screen Info

    private func updateNowPlayingInfo(for station: RadioStation) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: station.name,
            MPMediaItemPropertyAlbumTitle: station.city,
            MPNowPlayingInfoPropertyIsLiveStream: true,
            MPNowPlayingInfoPropertyPlaybackRate: 1.0
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        if let logoURL = station.logoUrl,
           let url = URL(string: logoURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }

                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }

                DispatchQueue.main.async {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                }
            }.resume()
        }
    }

    private func updatePlaybackState() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
    }

    // MARK: - Remote Controls

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            guard let self = self, let station = self.currentStation else { return .commandFailed }
            self.play(station: station)
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
    }
}
