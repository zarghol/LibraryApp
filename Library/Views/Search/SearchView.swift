//
//  SearchView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @EnvironmentObject var searchEngine: SearchEngine
    @EnvironmentObject var errorStore: ErrorStore

    @FetchRequest
    private var suggestions: FetchedResults<Search>

    init() {
        let request = Search.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Search.timestamp,
                ascending: false
            )
        ]
        request.fetchLimit = 5

        _suggestions = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        if searchEngine.results.isEmpty {
            List {
                if !searchEngine.currentSearch.isEmpty && searchEngine.author == nil {
                    Button("Search as author") {
                        searchEngine.addAsAuthor()
                    }
                }
                if !suggestions.isEmpty {
                    Section {
                        ForEach(suggestions) { suggestion in
                            Button(action: {
                                withAnimation {
                                    _ = Task { @MainActor in
                                        do {
                                            try await searchEngine.apply(suggestion)
                                        } catch {
                                            errorStore.catchError(error: error)
                                        }
                                    }
                                }
                            }, label: {
                                VStack(alignment: .leading) {
                                    if let query = suggestion.query {
                                        Text(query)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                    }

                                    if let author = suggestion.author {
                                        Text(author)
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            })
                        }
                    } header: {
                        HStack {
                            Text("Suggestions")

                            Spacer()

                            // TODO: in a futur version
                            if false {
                                Button("Clear") {
                                    withAnimation {
                                        searchEngine.clearSuggestions()
                                    }
                                }
                                .font(.caption)
                            }
                        }
                    }
                }
            }
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    Section {
                        ForEach(searchEngine.results, id: \.id) { book in
                            NavigationLink(value: AnyAPIBook(wrapped: book)) {
                                SearchResultBookView(book: book)
                            }
                        }
                    } header: {
                        HStack {
                            Text("\(searchEngine.results.count) results")
                        }
                        .font(.footnote.bold().uppercaseSmallCaps())

                    }
                }
                .padding()
            }
            .navigationDestination(for: AnyAPIBook.self) { book in
                BookDetailView(
                    image: book.imageURL.map { .distantUrl($0) },
                    bookIdentifier: book.id,
                    title: book.title,
                    description: book.description ?? "",
                    author: book.authors.first ?? "",
                    shouldDismissOnDelete: false
                )
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchEngine())
    }
}
