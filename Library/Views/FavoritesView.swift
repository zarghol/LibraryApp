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
                            FavoritesBookView(book: book)
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
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
