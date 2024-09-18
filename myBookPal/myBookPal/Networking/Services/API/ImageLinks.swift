//
//  ImageLinks.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import Foundation

struct ImageLinks: Codable, Hashable, Sendable {
    let smallThumbnail: String
    let thumbnail: String
    
    var secureThumbnailURL: String? {
        let getThumbnail = thumbnail
        let httpsThumbnail = getThumbnail.replacingOccurrences(of: "http://", with: "https://")
        return httpsThumbnail.replacingOccurrences(of: "&edge=curl", with: "")
    }
}
