//
//  TopEntryGatewayFetchMoreSuccessfullyStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 14.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchMoreSuccessfullyStub: TopEntryGatewayDummy {

    let items: [TopEntry]

    init(_ items: [TopEntry] = [.stub0]) {
        self.items = items
    }

    override func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        completion(.success(items))
        return nil
    }

}
