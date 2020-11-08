//
//  TopEntryGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

typealias TopEntryGatewayFetchCompletion = (_ result: Result<[TopEntry], Error>) -> Void

protocol TopEntryGateway {

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion)
    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion)

}

class TopEntryGatewayImpl: EntityGateway, TopEntryGateway {

    private var lastListing: Listing<TopEntry>?

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) {
        lastListing = nil
        performFetch(completion: completion)
    }

    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) {
        guard let listing = lastListing, let next = listing.next else {
            completion(.success([]))
            return
        }
        let queryItems = ["after": next]
        performFetch(with: queryItems, completion: completion)
    }

    private func performFetch(with query: [String: String]? = nil,
                       completion: @escaping TopEntryGatewayFetchCompletion) {
        perform { builder in
            builder.path = "/top.json"
            builder.queryItems = query
        } completion: { [weak self] (result: Result<Listing<TopEntry>, Error>) in
            switch result {
            case .success(let listing):
                self?.lastListing = listing
                let entityList = listing.children.map({ $0.element })
                completion(.success(entityList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
