//
//  AppRootView.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import SwiftUI

struct AppRootView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("welcome")
                Spacer()
            }
            .navigationTitle(Text("Library"))
            .searchable(text: .constant(""))
        }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
