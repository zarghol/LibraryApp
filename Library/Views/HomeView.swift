//
//  HomeView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        if isSearching {
            SearchView()
        } else {
            FavoritesView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
