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

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Search.timestamp!,
                ascending: true
            )
        ],
        animation: .default
    )
    private var suggestions: FetchedResults<Search>

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
                        Button(suggestion.query!) {

                        }
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
