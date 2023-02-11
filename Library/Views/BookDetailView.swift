//
//  BookDetailView.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import SwiftUI

enum ImageDefinition {
    case distantUrl(URL)
    case local(Data)
}

struct BookDetailView: View {
    let image: ImageDefinition
    let bookIdentifier: String
    let title: String
    let description: String
    let author: String

    @Environment(\.dismiss) var dismiss

    @StateObject var favoritesStore = FavoritesStore()

    @ViewBuilder
    var imageView: some View {
        switch image {
        case .distantUrl(let url):
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        case .local(let data):
            Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                imageView
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .shadow(radius: 2)

                Text(title)
                    .font(.headline)

                Text(author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if !description.isEmpty {
                    Text(description)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(uiColor: UIColor.systemGroupedBackground))
                        }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    do {
                        try favoritesStore.removeFavorite(bookIdentifier: bookIdentifier)
                        dismiss()

                    } catch {
                        print("error : \(error)")
                    }
                } label: {
                    Image(systemName: "bookmark.slash.fill")
                }

            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(
            image: .local(Data()),
            bookIdentifier: "",
            title: "",
            description: "",
            author: ""
        )
    }
}
