//
//  TopEntryGatewayMock.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import XCTest
@testable import SimpleRedditClient

class TopEntryGatewayMock: TopEntryGateway {
    
    private var log: [Action] = []

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) {
        log.append(.fetch)
    }
    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) {
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
}

extension TopEntryGatewayMock {

    enum Action {
        case fetch
        case fetchMore
    }

}
