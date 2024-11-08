//
//  BreedsView.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import SwiftUI

struct BreedsView: View {
    var gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @ObservedObject private(set) var viewModel: BreedsListViewModel
    @State var text: String = ""

    var body: some View {
        switch viewModel.state {
        case .loading(let result):
            NavigationStack {
                showCatList(result)
                .redacted(reason: .placeholder)
                .task {
                    await viewModel.load()
                }
                .searchable(text: $text)
                .navigationTitle("Cats 😺")
            }

        case .loaded(let result):
            NavigationStack {
                showCatList(result)
                .refreshable {
                    await viewModel.load()
                }
                .searchable(text: $text)
                .navigationTitle("Cats 😺")
            }
        case .loadingMore(result: let result):
            Text("loading more")
        case .empty:
            Text("Empty")
        case .failed:
            Text("Failed")
        }
    }

    private func destinationView(_ breed: BreedDetail) -> some View {
        Text(breed.name)
    }

    private func showCatList(_ breed: [BreedDetail]) -> some View {
        return ScrollView {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(breed, id: \.id) { catBreed in
                    NavigationLink(destination: destinationView(catBreed)) {
                        catView(catBreed)
                            .padding(.vertical)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)
        }

    }
    private func catView( _ breed: BreedDetail) -> some View {
        VStack(spacing: 12) {
            catPicture(url: breed.imageUrl)
            Text(breed.name)
                .font(.caption)
                .foregroundStyle(.primary)
        }
    }

    private var placeHolder: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.2))
            SwiftUI.Image(systemName: "photo.artframe")
        }
    }

    @ViewBuilder private func catPicture(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                formatImage(image)
            case .failure:
                //async image sometimes fails. Calling a second time seems to be working 🤷🏼‍♂️
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        formatImage(image)
                    case .failure:
                        SwiftUI.Image(systemName: "exclamationmark.triangle")
                    default:
                        placeHolder
                    }
                }
            default:
                placeHolder
            }
        }
    }

    @ViewBuilder
    private func formatImage(_ image:  SwiftUI.Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(Rectangle())
            .overlay(Rectangle()
                .stroke(.gray, lineWidth: 1)
            )
            .clipped()
    }
}

#Preview {
    BreedsView(viewModel: BreedsListViewModelMock(state: .loaded(result: BreedDetail.mock)))
}
