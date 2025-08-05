//
//  LocalNotificationManagerTests.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 07/08/2025.
//

import XCTest
import UserNotifications
@testable import RadioStreamingApp

final class LocalNotificationManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        let center = UNUserNotificationCenter.current()
        let expectation = XCTestExpectation(description: "Remove existing notifications")
        center.removeAllPendingNotificationRequests()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testNotifyFavoriteSchedulesNotification() {
        let station = RadioStation(
            id: "1",
            name: "Test Station",
            frequency: "101.1",
            streamUrl: "",
            category: .music,
            city: "Warszawa",
            logoUrl: ""
        )

        let manager = LocalNotificationManager.shared
        manager.notifyFavorite(station: station, addedToFavoutites: true)

        let expectation = XCTestExpectation(description: "Wait for notification scheduling")

        // Poczekaj, aż powiadomienie zostanie zarejestrowane
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let match = requests.contains { request in
                    request.content.title == "Dodano do ulubionych!" &&
                    request.content.body == "\(station.name) (\(station.frequency))"
                }

                XCTAssertTrue(match, "Powiadomienie powinno zostać dodane do kolejki.")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
