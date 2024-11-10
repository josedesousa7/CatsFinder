//
//  BreedsListViewModelTests.swift
//  CatsPediaTests
//
//  Created by José Marques on 10/11/2024.
//

import Testing
import Foundation
@testable import CatsPedia

@MainActor
struct BreedsListViewModelTests {

    @Test func viewModelLoadedSuccessfully() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        let sut = BreedsListViewModel(repository: mockRepository)
        //when
        await sut.load()
        let expectedState = sut.state
        //then
        #expect(expectedState == .loaded(result: BreedDetail.mock))
    }

    @Test func viewModelFetchMore() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        mockRepository.fetchedResults = (1...5).map {
            BreedDetail(
                id: "id - 1 - \($0)",
                name: "name - 1 - \($0)",
                lifeSpan: "span - 1 - \($0)",
                origin: "oring - 1 - \($0)",
                temperament: "temperament - 1 - \($0)",
                description: "descrioption - 1 - \($0)",
                imageUrl: nil,
                isFavourite: false
            )
        }
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()
        await sut.loadMore(after: BreedDetail.mock[17])

        //then
        #expect(sut.state.results.count == 25)
    }

    @Test func viewModelSearchResults() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()
        sut.filterResultsFor("mock name - 3")

        //then
        #expect(sut.state.results.count == 1)
    }

    @Test func viewModelCreateFavoriteSuccess() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        mockRepository.successMessageFavorite = "SUCCESS" 
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()

        let newFavourite = try #require(sut.state.results.first)
        #expect(newFavourite.isFavourite == false)
        await sut.createFavorite(breed: newFavourite)

        //then
        let updatedItem = try #require(sut.state.results.first)
        #expect(updatedItem.isFavourite == true)
        #expect(updatedItem.favouriteId == 3)
    }

    @Test func viewModelCreateFavoriteFailed() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()

        let newFavourite = try #require(sut.state.results.first)
        #expect(newFavourite.isFavourite == false)
        await sut.createFavorite(breed: newFavourite)

        //then
        let updatedItem = try #require(sut.state.results.first)
        #expect(updatedItem.isFavourite == false)
        #expect(updatedItem.favouriteId == nil)
    }

    @Test func viewModelCreateFavoriteSuccessFromDetail() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        mockRepository.successMessageFavorite = "SUCCESS"
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()

        let newFavourite = try #require(sut.state.results.first)
        #expect(newFavourite.isFavourite == false)
        let result = await sut.favouriteOrUnfavouriteForDetail(newFavourite)

        //then

        #expect(result.isFavourite == true)
        #expect(result.favouriteId == 3)
    }

    @Test func viewModelRemoveFavouriteFromDetail() async throws {
        //given
        let mockRepository = BreedsRepositoryMock()
        mockRepository.successResponseRemoveFavorite = true
        let sut = BreedsListViewModel(repository: mockRepository)

        // when
        await sut.load()

        var favoriteToBeRemoved = try #require(sut.state.results.first)
        favoriteToBeRemoved.isFavourite.toggle()
        #expect(favoriteToBeRemoved.isFavourite == true)
        let result = await sut.favouriteOrUnfavouriteForDetail(favoriteToBeRemoved)

        //then

        #expect(result.isFavourite == false)
        #expect(result.favouriteId == nil)
    }
}
