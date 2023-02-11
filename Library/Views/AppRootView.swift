//
//  AppRootView.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var searchEngine = SearchEngine()
    @StateObject private var errorStore = ErrorStore()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                HomeView()

                if let errorString = errorStore.errorString {
                    Text(errorString)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(uiColor: UIColor.quaternarySystemFill))
                        }
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .opacity
                            )
                        )
                }
            }
            .navigationTitle(Text("Library"))
            .searchable(text: $searchEngine.currentSearch, tokens: searchEngine.tokenBinding) { token in
                Label(token.author, systemImage: "person.circle")
            }
            .onSubmit(of: .search) {
                withAnimation {
                    errorStore.error = nil
                    Task { @MainActor in
                        do {
                            try await searchEngine.search(isFromSuggestion: false)
                        } catch {
                            errorStore.catchError(error: error)
                        }
                    }
                }
            }
            .onChange(of: searchEngine.currentSearch, perform: { newValue in
                errorStore.error = nil
                searchEngine.invalidateResults()
            })
            .environmentObject(searchEngine)
            .environmentObject(errorStore)
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
