//
//  BreedsView.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import SwiftUI

struct BreedsView: View {
    var gridItems: [GridItem] = (1...3).map { _ in
        GridItem(.flexible())
    }

    @ObservedObject private(set) var viewModel: BreedsListViewModel
    @State var text: String = ""

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading(let result):
                showCatList(result)
                    .redacted(reason: .placeholder)
                    .task {
                        await viewModel.load()
                    }

            case .loaded(let result), .loadingMore(result: let result), .searchResult(let result):
                showCatList(result)
            case .empty:
                Text("Empty")
            case .failed:
                ErrorView {
                    Task {
                        await viewModel.load()
                    }
                }
            case .partiallyFailed(let result):
                showCatList(result)
            }
        }
        .onChange(of: text) {
            viewModel.filterResultsFor(text)
        }
        .searchable(text: $text)
    }

    private func destinationView(_ breed: BreedDetail) -> some View {
        Text(breed.name)
    }

    private func showCatList(_ breed: [BreedDetail]) -> some View {
        return ScrollView {
            VStack {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(breed, id: \.id) { catBreed in
                        NavigationLink(destination: BreedDetailView(breed: catBreed)
                            .environmentObject(viewModel)) {
                            BreedView(
                                name: catBreed.name,
                                caption: nil,
                                isFavourite: catBreed.isFavourite,
                                imageUrl: catBreed.imageUrl
                            ) {
                                Task {
                                    await viewModel.createFavorite(breed: catBreed)
                                }
                            }
                            .padding(.vertical)
                            .onAppear {
                                Task {
                                    await viewModel.loadMore(after: catBreed)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .refreshable {
            await viewModel.load()
        }
        .navigationTitle("Cats 😺")
    }
    
}

#Preview("Loaded") {
    BreedsView(
        viewModel: BreedsListViewModelMock(
            state: .loaded(result: BreedDetail.mock)
        )
    )
}

#Preview("Error") {
    BreedsView(
        viewModel: BreedsListViewModelMock(
            state: .failed
        )
    )
}
