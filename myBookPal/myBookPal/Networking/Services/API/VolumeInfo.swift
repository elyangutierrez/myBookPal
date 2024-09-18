//
//  VolumeInfo.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import Foundation

struct VolumeInfo: Codable, Hashable, Sendable {
    let title: String
    let authors: [String]?
    let pageCount: Int?
    let categories: [String]?
    var imageLinks: ImageLinks?
    
    var getAuthor: String {
        guard let writers = authors else {
            return "N/A"
        }
        for author in writers {
            return author
        }
        return ""
    }
    
    var getCatagory: String {
        guard let c = categories else {
            return "N/A"
        }
        for catagory in c {
            return catagory
        }
        return ""
    }
    
    var getPageCount: String {
        guard let x = pageCount else {
            return "N/A"
        }
        return String(x)
    }
}
