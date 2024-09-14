//
//  Tag.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/14/24.
//

import Foundation

struct Tag: Hashable, Codable, Identifiable {
    var id = UUID()
    var text: String
    var color: String
}
