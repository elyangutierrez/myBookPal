//
//  StarRating.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/7/24.
//

import Foundation

struct StarRating: Hashable, Codable, Identifiable {
    var id = UUID()
    var rating: Double
}
