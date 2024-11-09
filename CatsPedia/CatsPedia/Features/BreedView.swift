//
//  BreedView.swift
//  CatsPedia
//
//  Created by José Marques on 09/11/2024.
//

import SwiftUI

struct BreedView: View {
    let model: BreedDetail
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            catPicture(for: model)
            Text(model.name)
                .font(.caption)
                .foregroundStyle(.primary)
        }
    }

    @ViewBuilder private func catPicture(for breed: BreedDetail) -> some View {
        ZStack (alignment: .topTrailing) {
            SwiftUI.Image(systemName: model.isFavourite ? "star.fill" : "star")
                .foregroundColor(.yellow)
                .zIndex(1)
                .padding(.trailing, 4)
                .padding(.top, 4)
                .onTapGesture {
                    action()
                }
            AsyncImage(url: breed.imageUrl) { image in
                formatImage(image)
            } placeholder: {
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

    private var placeHolder: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.2))
            SwiftUI.Image(systemName: "photo.artframe")
        }
    }
}

#Preview {
    BreedView(
        model: .init(
            id: "mock id",
            name: "mock name",
            imageUrl: nil,
            isFavourite: true
        ),
        action: { }
    )
}
