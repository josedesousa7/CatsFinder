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
        } catch {
            state = .failed
        }
    }

    func loadMore() async {
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
