//
//  CancellationToken.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import Foundation

protocol CancellationToken: AnyObject {

    func cancel()

}
