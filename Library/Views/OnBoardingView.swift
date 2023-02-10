//
//  OnBoardingView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome")
                .font(.largeTitle.bold())
                .foregroundColor(.accentColor)
            Text("Search a book to begin !")
                .font(.title2)

            HStack {
                Spacer()
                ZStack {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)

                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .offset(x: -8, y: 5)
                }
                Spacer()
            }

            Spacer()
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
