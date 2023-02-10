//
//  SearchView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchEngine: SearchEngine

    @State private var suggestions: [String] = []

    var body: some View {
        List {
            if !searchEngine.currentSearch.isEmpty && searchEngine.author == nil {
                Button("Search as author") {
                    searchEngine.addAsAuthor()
                }
            }
            if !suggestions.isEmpty && searchEngine.results.isEmpty {
                Section {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button(suggestion) {
                            // TODO: handle suggestion
                        }
                    }
                } header: {
                    Text("Suggestions")
                }
            }

            Section {
                Text("real results")
            } header: {
                Text("Results")
            }
        }
        .onSubmit(of: .search) {
            searchEngine.search()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchEngine())
    }
}
