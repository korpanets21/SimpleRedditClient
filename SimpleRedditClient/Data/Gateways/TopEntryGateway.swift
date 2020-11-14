//
//  TopEntryGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

typealias TopEntryGatewayFetchCompletion = (_ result: Result<[TopEntry], Error>) -> Void

protocol TopEntryGateway {

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken?
    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken?

}

class TopEntryGatewayImpl: EntityGateway, TopEntryGateway {

    private var lastListing: Listing<TopEntry>?

    func fetch(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        lastListing = nil
        return performFetch(completion: completion)
    }

    func fetchMore(completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        guard let listing = lastListing, let next = listing.next else {
            completion(.success([]))
            return nil
        }
        let queryItems = ["after": next]
        return performFetch(with: queryItems, completion: completion)
    }

    private func performFetch(with query: [String: String]? = nil,
                       completion: @escaping TopEntryGatewayFetchCompletion) -> CancellationToken? {
        return perform { builder in
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
