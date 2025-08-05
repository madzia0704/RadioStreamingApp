//
//  RadioPlayerManagerTests.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 06/08/2025.
//

import XCTest
@testable import RadioStreamingApp
import AVFoundation

final class RadioPlayerManagerTests: XCTestCase {
    
    func testPlaySetsIsPlayingTrue() {
        let station = mockStations[0]
        let player = RadioPlayerManager()
        
        player.play(station: station)

        XCTAssertTrue(player.isPlaying, "Oczekiwano, że isPlaying będzie true po wywołaniu play()")
        XCTAssertNotNil(player.player)
        
        if let assetURL = (player.player?.currentItem?.asset as? AVURLAsset)?.url {
            XCTAssertEqual(assetURL, URL(string: station.streamUrl)!, "Oczekiwano, że AVPlayer ma poprawny URL")
        } else {
            XCTFail("Nie udało się pobrać URL z AVPlayer")
        }
    }
    
    func testPauseSetsIsPlayingFalse() {
        let station = mockStations[0]
        let player = RadioPlayerManager()
        
        player.play(station: station)
        player.pause()
        
        XCTAssertFalse(player.isPlaying, "Oczekiwano, że isPlaying będzie false po wywołaniu pause()")
    }
    
    func testTogglePlayback() {
        let station = mockStations[0]
        let player = RadioPlayerManager()
        
        player.togglePlayback(for: station)
        XCTAssertTrue(player.isPlaying)
        
        player.togglePlayback(for: station)
        XCTAssertFalse(player.isPlaying)
    }
}

