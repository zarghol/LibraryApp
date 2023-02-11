//
//  FavoritesBookView.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct FavoritesBookView: View {
    let book: Book

    var body: some View {
        VStack {
            if let picture = book.picture,
               let uiImage = UIImage(data: picture) {
                Image(uiImage: uiImage)
                    .scaledToFit()
                    .frame(height: 200)
                    .clipped()
                    .shadow(radius: 2)
            }

            ViewThatFits(in: .horizontal) {
                VStack(alignment: .leading) {
                    Text(book.title ?? "")
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .font(.headline)

                    Text(book.author ?? "")
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 22)

                VStack(alignment: .leading) {
                    Text(book.title ?? "")
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .font(.headline)

                    Text(book.author ?? "")
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesBookView(book: Book())
    }
}
