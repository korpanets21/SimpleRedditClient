//
//  TopEntry.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

struct TopEntry: Decodable, Equatable {

    let id: String
    let title: String
    let author: String
    let entryDate: Date
    let thumbnailURL: URL?
    let commentsCount: Int

}

extension TopEntry {

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case entryDate = "created_utc"
        case thumbnailURL = "thumbnail"
        case commentsCount = "num_comments"
    }

}
