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

    @FetchRequest
    private var suggestions: FetchedResults<Search>

    init() {
        let request = Search.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Search.timestamp!,
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
                                searchEngine.apply(suggestion)
                            }, label: {
                                VStack(alignment: .leading) {
                                    if let query = suggestion.query {
                                        Text(query)
                                            .font(.body)
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
                        Text("Suggestions")
                    }
                }
            }
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    Section {
                        ForEach(searchEngine.results, id: \.id) { book in
                            SearchResultBookView(
                                title: book.title,
                                author: book.authors.first ?? "",
                                description: book.description ?? "",
                                imageUrl: book.imageURL
                            )
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
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchEngine())
    }
}
