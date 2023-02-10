//
//  AppRootView.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var searchEngine = SearchEngine()

    var body: some View {
        NavigationView {
            HomeView()
                .navigationTitle(Text("Library"))
                .searchable(text: $searchEngine.currentSearch, tokens: searchEngine.tokenBinding) { token in
                    Label(token.author, systemImage: "person.circle")
                }
                .environmentObject(searchEngine)
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
