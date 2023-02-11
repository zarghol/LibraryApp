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

    func url(bookIdentifier: String) -> URL {
        switch self {
        case .distantUrl(let url):
            return url
        case .local(let data):
            let url = FileManager.default.temporaryDirectory.appending(path: bookIdentifier)
            try? data.write(to: url)
            return url
        }
    }
}

struct BookDetailView: View {
    let image: ImageDefinition?
    let bookIdentifier: String
    let title: String
    let description: String
    let author: String

    let shouldDismissOnDelete: Bool

    @Environment(\.dismiss) var dismiss

    @StateObject var favoritesStore: FavoritesStore
    @State private var isBookmarked: Bool

    init(image: ImageDefinition?, bookIdentifier: String, title: String, description: String, author: String, shouldDismissOnDelete: Bool) {
        self.image = image
        self.bookIdentifier = bookIdentifier
        self.title = title
        self.description = description
        self.author = author
        self.shouldDismissOnDelete = shouldDismissOnDelete
        let favoriteStore = FavoritesStore()
        self._favoritesStore = StateObject(wrappedValue: favoriteStore)
        self._isBookmarked = State(initialValue: favoriteStore.isFavorite(bookIdentifier: bookIdentifier))
    }

    @ViewBuilder
    var imageView: some View {
        if let image {
            switch image {
            case .distantUrl(let url):
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            case .local(let data):
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                }
            }
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
                        if isBookmarked {
                            try favoritesStore.removeFavorite(bookIdentifier: bookIdentifier)
                            isBookmarked = false
                            if shouldDismissOnDelete {
                                dismiss()
                            }
                        } else {
                            Task {
                                try await favoritesStore.addFavorite(
                                    book: LocalAPIBook(
                                        id: bookIdentifier,
                                        title: title,
                                        authors: [author],
                                        description: description,
                                        imageURL: image?.url(bookIdentifier: bookIdentifier)
                                    )
                                )
                                isBookmarked = true
                            }
                        }
                    } catch {
                        print("error : \(error)")
                    }
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.slash.fill" : "bookmark.fill")
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
            author: "",
            shouldDismissOnDelete: false
        )
    }
}
