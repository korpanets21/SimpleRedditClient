//
//  TopEntryGatewayFetchSuccessfullyStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchSuccessfullyStub: TopEntryGatewayDummy {

    let items: [TopEntry]

    init(_ items: [TopEntry] = [.stub0]) {
        self.items = items
    }

    override func fetch(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        completion(.success(items))
        return nil
    }

}
