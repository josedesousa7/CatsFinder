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
    let cats: [Breed] = (1...20).map {
        Breed(
            id: "id - \($0)",
            name: "mock name \($0)",
            origin: "",
            temperament: "",
            description: "",
            image: nil
        )
    }

    @State var text: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(cats, id: \.id) { catBreed in
                        NavigationLink(destination: destinationView(catBreed)) {
                            catView(catBreed)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical)
            }
            .searchable(text: $text)
            .navigationTitle("Cats 😺")
        }

    }

    private func destinationView(_ breed: Breed) -> some View {
        Text(breed.name ?? "")
    }

    private func catView( _ breed: Breed) -> some View {
        VStack(spacing: 12) {
            placeHolder
            Text(breed.name ?? "")
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
}

#Preview {
    let breeds: [Breed] = (1...20).map {
        Breed(
            id: "id - \($0)",
            name: "mock name \($0)",
            origin: "",
            temperament: "",
            description: "",
            image: nil
        )
    }
    BreedsView()
}
