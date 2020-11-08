//
//  TopEntryListViewMock.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopEntryListViewMock: TopEntryListView {

    private var log: [Action] = []
    private var items: [TopEntryViewModel] = []
    private var message: String = ""

    func show(items: [TopEntryViewModel]) {
        log.append(.showItems)
        self.items = items
    }

    func showAlertWith(message: String) {
        log.append(.showAlertWithMessage)
        self.message = message
    }

    func verifyCalled(_ action: Action) {
        XCTAssertEqual([action], log)
    }

    func verifyContains(_ expectedItems: [TopEntryViewModel]) {
        XCTAssertEqual(expectedItems, items)
    }

    func verifyMessageFormat(_ expectedMessage: String) {
        XCTAssertEqual(expectedMessage, message)
    }

    func clear() {
        log = []
        items = []
        message = ""
    }

}

extension TopEntryListViewMock {

    enum Action {
        case showItems
        case showAlertWithMessage
    }

}
