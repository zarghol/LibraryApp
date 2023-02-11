//
//  SearchResultBookView.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import SwiftUI
import Dependencies

struct SearchResultBookView: View {
    let book: APIBook

    @StateObject var favoritesStore: FavoritesStore

    @State private var isBookmarked: Bool

    init(book: APIBook) {
        self.book = book
        let store = FavoritesStore()
        self._favoritesStore = StateObject(wrappedValue: store)
        self._isBookmarked = State(initialValue: store.isFavorite(bookIdentifier: book.id))
    }

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                AsyncImage(url: book.imageURL) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ZStack {
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray.opacity(0.2))

                        ProgressView()
                    }
                }
                .frame(height: 250)
                .shadow(radius: 2)

                HStack {
                    Spacer()

                    Button {
                        do {
                            if isBookmarked {
                                try favoritesStore.removeFavorite(bookIdentifier: book.id)
                                isBookmarked = false
                            } else {
                                Task {
                                    try await favoritesStore.addFavorite(book: book)
                                    isBookmarked = true
                                }
                            }
                        } catch {
                            print("error : \(error)")
                        }
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.circle.fill" :  "bookmark.circle")
                            .resizable()
                            .renderingMode(.original)
                            .foregroundColor(.white)
                    }
                    .frame(width: 30, height: 30)
                    .padding([.top, .trailing], 8)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(book.title)
                        .font(.headline)

                    Spacer()

                    Text(book.authors.first ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .lineLimit(1)
                            .font(.headline)

                        Text(book.authors.first ?? "")
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                Text(book.title)
                    .lineLimit(1)
                    .font(.headline)
            }

            if let description = book.description {
                Text(description)
                    .lineLimit(5)
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultBookView(
            book: GoogleAPIBook(
                id: UUID().uuidString,
                url: URL(string: "https://")!,
                title: "Porteur",
                authors: ["Brent Weeks"],
                description: "Test"
            )
        )
    }
}
