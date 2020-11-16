//
//  TopEntryGatewayFetchMoreFailingStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 08.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchMoreFailingStub: TopEntryGatewayDummy {

    let error = TestError.default

    override func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        completion(.failure(self.error))
        return nil
    }

}
