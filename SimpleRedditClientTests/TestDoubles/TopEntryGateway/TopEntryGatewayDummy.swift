//
//  TopEntryGatewayDummy.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

class TopEntryGatewayDummy: TopEntryGateway {

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        return nil
    }
    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) -> CancellationToken? {
        return nil
    }

}
