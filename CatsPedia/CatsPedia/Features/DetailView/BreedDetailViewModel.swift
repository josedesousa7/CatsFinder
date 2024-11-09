//
//  BreedsViewModel.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

@MainActor
class BreedDetailViewModel: ObservableObject {
    enum State: Equatable {
        case loaded(result: BreedDetail)
        case partiallyFailed(result: BreedDetail)
    }

    @Published var state: State
    private let repository: BreedsRepositoryProtocol


    init(repository: BreedsRepositoryProtocol = BreedsRepository(), breed: BreedDetail) {
        self.repository = repository
        self.state = .loaded(result: breed)
    }

    //MARK: - Network
    func favoriteOrUnfavorite(breed: BreedDetail) async {
        guard case .loaded(let result) = state else { return }
              if breed.isFavourite == false {
                  do {
                      let response = try await repository.createFavorite(for: breed)
                      guard let favoriteId = response.id else { return }
                      if response.message == "SUCCESS" {
                          var updatedResult = result
                          var isFavorite = breed.isFavourite
                          isFavorite.toggle()
                          updatedResult.update(with: isFavorite, id: favoriteId)
                          state = .loaded(result: updatedResult)
                      }
                  }
                  catch {
                      // loading more failed, keep the list with the current results
                      state = .partiallyFailed(result: result)
                  }
              }

        else {
            do {
                let response = try await repository.removeFavorite(for: breed)
                if response {
                    var updatedResult = result
                    var isFavorite = breed.isFavourite
                    isFavorite.toggle()
                    updatedResult.update(with: isFavorite, id: nil)
                    state = .loaded(result: updatedResult)
                }
            }
            catch {
                // loading more failed, keep the list with the current results
                state = .partiallyFailed(result: result)
            }
        }
    }
}

#if targetEnvironment(simulator)
final class BreedDetailViewModelMock: BreedDetailViewModel {
    let breed = BreedDetail(
        id: "",
        name: "Mock name -1",
        lifeSpan: nil,
        origin: "Australia",
        temperament: "Agile, Easy Going, Intelligent, Playful",
        description: "The Munchkin is an outgoing cat who enjoys being handled. She has lots of energy and is faster and more agile than she looks. The shortness of their legs does not seem to interfere with their running and leaping abilities.",
        imageUrl: nil,
        isFavourite: true
    )
    init(state: State) {
        super.init(repository: BreedsRepositoryMock(), breed: breed)
        self.state = state
    }
}
#endif
