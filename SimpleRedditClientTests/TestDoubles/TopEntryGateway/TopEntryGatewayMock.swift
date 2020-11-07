//
//  TopEntryGatewayMock.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

import XCTest
@testable import SimpleRedditClient

final class TopEntryGatewayMock: TopEntryGateway {

    private var log: [Action] = []

    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) {
        log.append(.fetchMore)
    }

    func verifyCalled(_ action: Action) {
        XCTAssertEqual([action], log)
    }
}

extension TopEntryGatewayMock {

    enum Action {
        case fetchMore
    }

}
