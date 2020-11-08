//
//  TopEntryGatewayDummy.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

class TopEntryGatewayDummy: TopEntryGateway {

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) { }
    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) { }

}
