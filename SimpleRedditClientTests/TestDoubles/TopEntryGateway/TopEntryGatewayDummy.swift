//
//  TopEntryGatewayDummy.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 05.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryGatewayDummy: TopEntryGateway {

    func fetchMore(completion: (Result<[TopEntry], Error>) -> Void) { }
    
}
