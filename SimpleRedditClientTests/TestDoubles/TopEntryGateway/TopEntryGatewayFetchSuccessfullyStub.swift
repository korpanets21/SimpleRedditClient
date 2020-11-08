//
//  TopEntryGatewayFetchSuccessfullyStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchSuccessfullyStub: TopEntryGatewayMock {

    let items: [TopEntry]

    init(_ items: [TopEntry] = [.stub0]) {
        self.items = items
    }

    override func fetch(completion: @escaping TopEntryGatewayFetchCompletion) {
        super.fetch(completion: completion)
        completion(.success(items))
    }

    override func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) {
        super.fetchMore(completion: completion)
        completion(.success(items))
    }

}
