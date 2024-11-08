//
//  BreedsViewModel.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

@MainActor
class BreedsListViewModel: ObservableObject {
    enum State: Equatable {
        case loaded(result: [BreedDetail])
        case loading(result: [BreedDetail])
        case loadingMore(result: [BreedDetail])
        case searchResult(result: [BreedDetail])
        case partiallyFailed(result: [BreedDetail])
        case empty
        case failed

        var isLoading: Bool {
            guard case .loading = self else { return false }
            return true
        }

        var isLoadingMore: Bool {
            guard case .loadingMore = self else { return false }
            return true
        }

        var hasLoaded: Bool {
            guard case .loaded = self else { return false }
            return true
        }
    }

    @Published var state: State = .loading(result: BreedDetail.mock)
    private var availableBreeds: [BreedDetail] = []
    @Published private var searchResults: [BreedDetail] = []

    private let repository: BreedsRepositoryProtocol
    private var page: Int = 0

    init(repository: BreedsRepositoryProtocol) {
        self.repository = repository
    }

    //MARK: - Network

    func load() async {
        await loadFirst()
    }

    private func loadFirst() async {
        do {
            let result = try await repository.fetchBreedList()
            state = .loaded(result: result)
            self.availableBreeds = result
            page = 0
        } catch {
            state = .failed
        }
    }

    func loadMore(after breed: BreedDetail) async {
        guard case .loaded(let result) = state, state.hasLoaded else {return }
        let thresholdIndex = result.index(result.endIndex, offsetBy: -1)
        if result.firstIndex(where: { $0.id == breed.id }) == thresholdIndex {
            state = .loadingMore(result: result)
               do {
                   page += 1
                   let newBreeds = try await repository.fetchMoreBreeds(page: page)
                   self.availableBreeds = result + newBreeds
                   state = .loaded(result: result + newBreeds)
               } catch {
                   // loading more failed, keep the list with the current results
                   state = .partiallyFailed(result: result)
               }
           }
    }

    func filterResultsFor(_ keyword: String) {
        if keyword.isEmpty {
            state = .loaded(result: availableBreeds)
            return
        }
        searchResults = availableBreeds
        let searchResult = searchResults.filter{ $0.name.contains(keyword) }
        state = .searchResult(result: searchResult)

    }
}

extension BreedDetail {
    static let mock = (1...20).map {
        BreedDetail(
            id: "id - \($0)",
            name: "mock name - \($0)",
            imageUrl: nil,
            isFavorite: false
        )
    }
}

#if targetEnvironment(simulator)
final class BreedsListViewModelMock: BreedsListViewModel {
    init(state: State) {
        super.init(repository: BreedsRepositoryMock())
        self.state = state
    }
}
#endif
