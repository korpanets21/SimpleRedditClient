//
//  TopEntryGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

typealias TopEntryGatewayFetchCompletion = (_ result: Result<[TopEntry], Error>) -> Void

protocol TopEntryGateway {

    func fetchMore(completion: TopEntryGatewayFetchCompletion)

}
