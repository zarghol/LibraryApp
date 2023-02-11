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
                ascending: true
            )
        ]
        request.fetchLimit = 5

        _suggestions = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        List {
            if !searchEngine.currentSearch.isEmpty && searchEngine.author == nil {
                Button("Search as author") {
                    searchEngine.addAsAuthor()
                }
            }
            if !suggestions.isEmpty && searchEngine.results.isEmpty {
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

            Section {
                ForEach(searchEngine.results, id: \.id) { book in
                    Text(book.title)
                }
            } header: {
                Text("Results")
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
