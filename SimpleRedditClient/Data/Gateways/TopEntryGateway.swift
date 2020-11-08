//
//  TopEntryGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

typealias TopEntryGatewayFetchCompletion = (_ result: Result<[TopEntry], Error>) -> Void

protocol TopEntryGateway {

    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion)

}

class TopEntryGatewayImpl: EntityGateway, TopEntryGateway {

    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) {
        perform { builder in
            builder.path = "/top.json"
        } completion: { (result: Result<Listing<TopEntry>, Error>) in
            switch result {
            case .success(let listing):
                let entityList = listing.children.map({ $0.element })
                completion(.success(entityList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
