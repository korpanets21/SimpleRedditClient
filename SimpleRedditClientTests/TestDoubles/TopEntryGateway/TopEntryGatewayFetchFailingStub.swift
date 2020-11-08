//
//  TopEntryGatewayFetchFailingStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchFailingStub: TopEntryGatewayDummy {

    let error = TestError.default

    override func fetch(completion: @escaping TopEntryGatewayFetchCompletion) {
        completion(.failure(error))
    }

}
