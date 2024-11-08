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
                   state = .loaded(result: result + newBreeds)
               } catch {
                   // loading more failed, keep the list with the current results
                   state = .partiallyFailed(result: result)
               }
           }
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
