//
//  TopEntryAuthorInfoFormatterTests.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopEntryAuthorInfoFormatterTests: TestCase {

    func testInfoStringForAnEntryCreatedOneHourAgo() {
        let topEntry = TopEntry.stubCreatedAnHourAgo
        let expectedString = "\(topEntry.author) - 1 hour ago"
        XCTAssertEqual(expectedString, TopEntryAuthorInfoFormatter().infoString(for: topEntry))
    }

    func testInfoStringForAnEntryCreatedTwoHoursAgo() {
        let topEntry = TopEntry.stubCreatedTwoHoursAgo
        let expectedString = "\(topEntry.author) - 2 hours ago"
        XCTAssertEqual(expectedString, TopEntryAuthorInfoFormatter().infoString(for: topEntry))
    }
}

private extension TopEntry {

    static let stubCreatedAnHourAgo = TopEntry(id: "",
                                               title: "",
                                               author: "author1",
                                               entryDate: Date(timeIntervalSinceNow: -(60 * 60)),
                                               thumbnailURL: nil,
                                               commentsCount: 0)
    static let stubCreatedTwoHoursAgo = TopEntry(id: "",
                                                 title: "",
                                                 author: "author2",
                                                 entryDate: Date(timeIntervalSinceNow: -(2 * 60 * 60)),
                                                 thumbnailURL: nil,
                                                 commentsCount: 0)
}
