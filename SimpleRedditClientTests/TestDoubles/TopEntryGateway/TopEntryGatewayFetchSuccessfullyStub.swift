//
//  TopEntryGatewayFetchSuccessfullyStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchSuccessfullyStub: TopEntryGateway {

    let entity = TopEntry.stub0

    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) {
        completion(.success([entity]))
    }

}
