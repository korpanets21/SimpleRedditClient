//
//  TopEntryGatewayMock.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopEntryGatewayMock: TopEntryGateway, CancellationToken {
    
    private var log: [Action] = []

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        log.append(.fetch)
        return self
    }
    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        log.append(.fetchMore)
        return self
    }

    func verifyCalled(_ action: Action) {
        XCTAssertTrue(log.contains(action))
    }

    func verifyWasNotCalled() {
        XCTAssertTrue(log.isEmpty)
    }

    func clear() {
        log = []
    }

    func cancel() {
        log.append(.cancel)
    }
}

extension TopEntryGatewayMock {

    enum Action {
        case fetch
        case fetchMore
        case cancel
    }

}
