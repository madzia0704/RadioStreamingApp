//
//  StationListViewModel.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 28/07/2025.
//
import Foundation
import Combine

final class StationListViewModel: ObservableObject {
    // MARK: - Published properties
    
    @Published var stations: [RadioStation] = []
    @Published var filteredStations: [RadioStation] = []

    @Published var searchText: String = ""
    @Published var selectedCategory: RadioCategory?
    @Published var cityFilter: String = ""
    
    @Published var useAPI: Bool = false {
        didSet {
            reloadStations()
        }
    }


    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false
    private let fetcher: RadioStationFetcher

    // MARK: - Init
    init(fetcher: RadioStationFetcher = RadioStationFetcher()) {
        self.fetcher = fetcher
        setupFiltering()
    }

    // MARK: - Public methods
    func loadStationsIfNeeded() {
        guard !hasLoaded else { return }
        hasLoaded = true
        fetchStations()
    }

    func reloadStations() {
        fetchStations()
    }
    
    var stationsPublisher: AnyPublisher<[RadioStation], Never> {
        $stations.eraseToAnyPublisher()
    }

    // MARK: - Fetching
    private func fetchStations(tag: String? = nil, name: String? = nil, city: String? = nil) {
        fetchFromAPI(useAPI: useAPI, tag: tag, name: name, city: city)

    }

    private func fetchFromAPI(useAPI: Bool, tag: String? = nil, name: String? = nil, city: String? = nil) {
        isLoading = true
        errorMessage = nil

        fetcher
            .fetchPublisher(useAPI: useAPI, tag: tag, name: name, city: city)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "❌ \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] stations in
                self?.stations = stations
                self?.filteredStations = stations
            }
            .store(in: &cancellables)
    }

    // MARK: - Filtering
    private func setupFiltering() {
        Publishers.CombineLatest3($searchText, $selectedCategory, $cityFilter)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .removeDuplicates(by: { lhs, rhs in
                lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
            })
            .map { [weak self] (search, category, city) in
                self?.filterStations(search: search, category: category, city: city) ?? []
            }
            .assign(to: &$filteredStations)
    }

    private func filterStations(search: String, category: RadioCategory?, city: String) -> [RadioStation] {
        stations.filter { station in
            let matchesSearch = search.isEmpty || station.name.localizedCaseInsensitiveContains(search)
            let matchesCategory = category == nil || station.category == category
            let matchesCity = city.isEmpty || station.city.localizedCaseInsensitiveContains(city)
            return matchesSearch && matchesCategory && matchesCity
        }
    }
}
