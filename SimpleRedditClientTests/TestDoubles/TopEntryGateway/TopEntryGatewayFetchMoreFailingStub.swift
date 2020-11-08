//
//  TopEntryGatewayFetchMoreFailingStub.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 08.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayFetchMoreFailingStub: TopEntryGateway {

    let firstPageItems: [TopEntry]
    let error = TestError.default

    init(_ firstPageItems: [TopEntry] = [.stub0]) {
        self.firstPageItems = firstPageItems
    }

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) {
        completion(.success(firstPageItems))
    }

    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) {
        completion(.failure(error))
    }

}
