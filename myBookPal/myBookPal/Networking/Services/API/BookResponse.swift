//
//  BookResponse.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import Foundation

struct BookResponse: Codable, Hashable, Sendable {
    let totalItems: Int
    let items: [BookItem]
}
