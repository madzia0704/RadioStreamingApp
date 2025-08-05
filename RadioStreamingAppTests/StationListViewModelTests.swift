//
//  StationListViewModelTests.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//

import XCTest
import Combine
@testable import RadioStreamingApp

final class StationListViewModelTests: XCTestCase {
    var viewModel: StationListViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = StationListViewModel()
        viewModel.stations = [
            RadioStation(id: "1", name: "Sport FM", frequency: "100.1", streamUrl: "", category: .sports, city: "Warszawa", logoUrl: ""),
            RadioStation(id: "2", name: "RMF Muzyka", frequency: "101.1", streamUrl: "", category: .music, city: "Kraków", logoUrl: ""),
            RadioStation(id: "3", name: "Sport News", frequency: "102.1", streamUrl: "", category: .sports, city: "Gdańsk", logoUrl: ""),
            RadioStation(id: "4", name: "RMF News", frequency: "102.1", streamUrl: "", category: .news, city: "Gdańsk", logoUrl: "")
        ]
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        UserDefaults.standard.set([], forKey: "FavoriteStationIDs")
        super.tearDown()
    }

    func testFilterByName() {
        viewModel.searchText = "RMF"

        let expectation = XCTestExpectation(description: "Wait for filtering")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let filtered = self.viewModel.filteredStations
            XCTAssertEqual(filtered.count, 2)
            XCTAssertTrue(filtered.allSatisfy { $0.name.localizedCaseInsensitiveContains("RMF") })
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterByCategory() {
        checkCategory(category: .music, expectedCount: 1)
        checkCategory(category: .sports, expectedCount: 2)
        checkCategory(category: .news, expectedCount: 1)
        checkCategory(category: .culture, expectedCount: 0)
    }

    private func checkCategory(category: RadioCategory, expectedCount: Int) {
        viewModel.selectedCategory = category

        let expectation = XCTestExpectation(description: "Wait for category filtering")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let filtered = self.viewModel.filteredStations
            XCTAssertEqual(filtered.count, expectedCount, "Expected \(expectedCount) for category \(category)")
            XCTAssertTrue(filtered.allSatisfy { $0.category == category })
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFavoriteToggle() {
        let manager = FavoritesManager()
        let station = viewModel.stations[0]
        let station1 = viewModel.stations[1]

        XCTAssertFalse(manager.isFavorite(station))
        XCTAssertFalse(manager.isFavorite(station1))
        manager.toggleFavorite(station)
        XCTAssertTrue(manager.isFavorite(station), "Oczekiwano, że stacja jest dodana do ulubionych")
        XCTAssertFalse(manager.isFavorite(station1), "Oczekiwano, że inna stacja nie jest dodana do ulubionych")
        
        manager.toggleFavorite(station)
        XCTAssertFalse(manager.isFavorite(station), "Oczekiwano, że stacja została usunięta z ulubionych")
    }
}
