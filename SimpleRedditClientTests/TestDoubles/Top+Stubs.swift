//
//  TopEntry+Stubs.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation
@testable import SimpleRedditClient

extension TopEntry {

    static let stub0 = TopEntry(id: "0",
                           title: "Title0",
                           author: "Author0",
                           entryDate: Date(),
                           thumbnailURL: nil,
                           commentsCount: 0)
    static let stub1 = TopEntry(id: "1",
                           title: "Title1",
                           author: "Author1",
                           entryDate: Date(),
                           thumbnailURL: nil,
                           commentsCount: 1)
    static let stub2 = TopEntry(id: "2",
                           title: "Title2",
                           author: "Author2",
                           entryDate: Date(),
                           thumbnailURL: nil,
                           commentsCount: 2)
    static let stub3 = TopEntry(id: "3",
                           title: "Title3",
                           author: "Author3",
                           entryDate: Date(),
                           thumbnailURL: nil,
                           commentsCount: 3)
}
