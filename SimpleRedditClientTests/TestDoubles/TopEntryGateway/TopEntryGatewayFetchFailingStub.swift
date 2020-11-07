//
//  TopEntryGatewayFetchFailingStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchFailingStub: TopEntryGateway {

    let error = TestError.default

    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) {
        completion(.failure(error))
    }

}
