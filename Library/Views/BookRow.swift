//
//  BookRow.swift
//  Library
//
//  Created by Admin on 09/02/2023.
//

import SwiftUI

struct BookRow: View {
    let book: Book

    var body: some View {
        HStack {
//            Image(
            VStack {
                Text(book.title!)

                Text(book.desc!)
            }
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: Book())
    }
}
