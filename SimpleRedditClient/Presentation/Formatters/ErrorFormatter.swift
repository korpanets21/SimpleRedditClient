//
//  ErrorFormatter.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

final class ErrorFormatter {

    func string(for error: Error) -> String {
        return error.localizedDescription
    }
}
