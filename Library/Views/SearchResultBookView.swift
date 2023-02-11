//
//  SearchResultBookView.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import SwiftUI

struct SearchResultBookView: View {
    let title: String
    let author: String
    let description: String
    let imageUrl: URL

    @State private var isBookmarked = false

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ZStack {
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray.opacity(0.2))

                        ProgressView()
                    }
                }
                .frame(height: 250)
                .shadow(radius: 2)

                HStack {
                    Spacer()

                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.circle.fill" :  "bookmark.circle")
                            .resizable()
                            .renderingMode(.original)
                            .foregroundColor(.white)
                    }
                    .frame(width: 30, height: 30)
                    .padding([.top, .trailing], 8)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(title)
                        .font(.headline)

                    Spacer()

                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .lineLimit(1)
                            .font(.headline)

                        Text(author)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                Text(title)
                    .lineLimit(1)
                    .font(.headline)
            }



            Text(description)
                .lineLimit(5)

        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultBookView(
            title: "Le couteau aveuglant",
            author: "",
            description: "",
            imageUrl: URL(string: "https://books.google.com/books/publisher/content?id=dRKHAQAAQBAJ&printsec=frontcover&img=1&zoom=1")!
        )
    }
}
