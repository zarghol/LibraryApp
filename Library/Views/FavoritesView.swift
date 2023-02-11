//
//  FavoritesView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct FavoritesView: View {
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Book.title,
                ascending: true
            )
        ],
        animation: .default
    )
    private var books: FetchedResults<Book>

    var body: some View {
        if books.isEmpty {
            OnBoardingView()
                .padding()
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Section {
                        ForEach(books) { book in
                            NavigationLink(value: book) {
                                FavoritesBookView(book: book)
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                // Filters
                Button {
                    // TODO: Add filters
                } label: {
                    Label("Filters", systemImage: "line.3.horizontal.decrease")
                        .labelStyle(.iconOnly)
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(
                    image: .local(book.picture!),
                    bookIdentifier: book.identifier!,
                    title: book.title ?? "",
                    description: book.desc ?? "",
                    author: book.author ?? "",
                    shouldDismissOnDelete: true
                )
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
