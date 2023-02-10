//
//  SearchView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct SearchView: View {
    @State private var suggestions: [String] = []

    var body: some View {
        List {
            if !suggestions.isEmpty {
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
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
