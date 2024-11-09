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
    @Published var favouritesBreeds: [BreedDetail] = []
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
            self.favouritesBreeds = availableBreeds.filter { $0.isFavourite }
            page = 0
        } catch {
            state = .failed
        }
    }

    func loadMore(after breed: BreedDetail) async {
        guard case .loaded(let result) = state, state.hasLoaded else { return }
        let thresholdIndex = result.index(result.endIndex, offsetBy: -3)
        if result.firstIndex(where: { $0.id == breed.id }) == thresholdIndex {
            state = .loadingMore(result: result)
               do {
                   page += 1
                   let newBreeds = try await repository.fetchMoreBreeds(page: page)
                   self.availableBreeds = result + newBreeds
                   self.favouritesBreeds = availableBreeds.filter { $0.isFavourite }
                   state = .loaded(result: result + newBreeds)
               } catch {
                   // loading more failed, keep the list with the current results
                   state = .partiallyFailed(result: result)
               }
           }
    }

    func createFavorite(breed: BreedDetail) async {
        guard case .loaded(let result) = state,
              let index = result.firstIndex(where: { $0.id == breed.id }),
              breed.isFavourite == false else { return }
        do {
            let response = try await repository.createFavorite(for: breed)
            guard let favoriteId = response.id else { return }
            if response.message == "SUCCESS" {
                var updatedResult = result
                var isFavorite = breed.isFavourite
                isFavorite.toggle()
                updatedResult[index].update(with: isFavorite, id: favoriteId)
                self.favouritesBreeds = updatedResult.filter { $0.isFavourite }
                state = .loaded(result: updatedResult)
            }
        }
        catch {
            // loading more failed, keep the list with the current results
            state = .partiallyFailed(result: result)
        }
    }


    func favoriteOrUnfavoriteForDetail(_ detailBreed: BreedDetail) async -> BreedDetail {
        var breed = detailBreed
        guard case .loaded(let result) = state,
              let index = result.firstIndex(where: { $0.id == breed.id }) else { return breed }
        if breed.isFavourite == false {
            do {
                let response = try await repository.createFavorite(for: breed)
                guard let favoriteId = response.id else { return breed }
                if response.message == "SUCCESS" {
                    var updatedResult = result
                    breed.isFavourite.toggle()
                    updatedResult[index].update(with: breed.isFavourite, id: favoriteId)
                    self.favouritesBreeds = updatedResult.filter { $0.isFavourite }
                    state = .loaded(result: updatedResult)
                    return breed
                }
            }
            catch {
                // loading more failed, keep the list with the current results
                state = .partiallyFailed(result: result)
                return breed
            }
        }

        else {
            do {
                let response = try await repository.removeFavorite(for: breed)
                if response {
                    var updatedResult = result
                    breed.isFavourite.toggle()
                    updatedResult[index].update(with: breed.isFavourite, id: nil)
                    self.favouritesBreeds = updatedResult.filter { $0.isFavourite }
                    state = .loaded(result: updatedResult)
                    return breed
                }
            }
            catch {
                // loading more failed, keep the list with the current results
                state = .partiallyFailed(result: result)
                return breed
            }
        }
        return breed
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
            lifeSpan: nil, origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: false
        )
    }
}

#if targetEnvironment(simulator)
final class BreedsListViewModelMock: BreedsListViewModel {
    init(state: State) {
        super.init(repository: BreedsRepositoryMock())
        self.state = state
        if case .loaded(let result) = state {
            super.favouritesBreeds = result.filter { $0.isFavourite }
        }
    }
}
#endif
