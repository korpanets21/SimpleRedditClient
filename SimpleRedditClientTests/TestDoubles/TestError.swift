//
//  TestError.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

enum TestError: Error, LocalizedError {

    case `default`

    var errorDescription: String? {
        return "Error for unit testing"
    }
}
