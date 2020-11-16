//
//  FetchTopEntriesInteractorMock.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 15.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class FetchTopEntriesInteractorMock: FetchTopEntriesInteractorInput {

    private var log: [Action] = []

    func fetch() {
        log.append(.fetch)
    }

    func fetchMore() {
        log.append(.fetchMore)
    }

    func verifyCalled(_ action: Action) {
        XCTAssertEqual([action], log)
    }
    func verifyWasNotCalled() {
        XCTAssertTrue(log.isEmpty)
    }

    func clear() {
        log = []
    }

    enum Action {
        case fetch
        case fetchMore
    }

}
