//
//  BreedDetailView.swift
//  CatsPedia
//
//  Created by José Marques on 09/11/2024.
//

import SwiftUI

struct BreedDetailView: View {
    @EnvironmentObject var viewModel: BreedsListViewModel
    @State var breed: BreedDetail

    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Text(breed.name)
                    .font(.largeTitle.bold())
                    .lineLimit(2)
                    .padding(.trailing, 4)
                Spacer()
                SwiftUI.Image(systemName: breed.isFavourite ? "star.fill" : "star")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                    .zIndex(1)
                    .padding(.trailing, 4)
                    .padding(.top, 4)
                    .onTapGesture {
                        Task {
                          let result =  await viewModel.favoriteOrUnfavoriteForDetail(breed)
                            self.breed = result

                        }
                    }
            }
            catPicture(for: breed.imageUrl)
            VStack(alignment: .center, spacing: 15) {
                if let origin = breed.origin {
                    Text(origin)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                if let temperament = breed.temperament {
                    Text(temperament)
                        .font(.subheadline)
                        .lineLimit(2)
                }

                if let description = breed.description {
                    Text(description)
                        .font(.subheadline)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal, 16)
    }


    @ViewBuilder private func catPicture(for url: URL?) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .imageWidth, height: .imageWidth)
                .clipShape(Rectangle())
                .overlay(Rectangle()
                    .stroke(.gray, lineWidth: 1)
                )
                .clipped()
        } placeholder: {
            placeHolder
        }
    }

    private var placeHolder: some View {
        ZStack {
            Rectangle()
                .frame(width: .imageWidth, height: .imageWidth)
                .foregroundColor(.gray.opacity(0.2))
            SwiftUI.Image(systemName: "photo.artframe")
        }
    }
}

private extension CGFloat {
    static let imageWidth = 300.0
}


#Preview {
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
    
    let mockViewModel: BreedsListViewModel = BreedsListViewModelMock(state: .loaded(result: BreedDetail.mock))
    BreedDetailView(breed: breed)
        .environmentObject(mockViewModel)
}
