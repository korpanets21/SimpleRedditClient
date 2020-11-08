//
//  RestClient.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

protocol RestClient {

    typealias Completion = (_ data: Data?, _ error: RestClientError?) -> Void

    func perform(_ request: URLRequest, _ completion: @escaping Completion)

}

class RestClientImpl: RestClient {

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()

    func perform(_ request: URLRequest, _ completion: @escaping Completion) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.handleNetworkError(error, completion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.handle(httpResponse: httpResponse, data: data, completion: completion)
            } else {
                completion(data, nil)
            }
        }
        task.resume()
    }

    private func handleNetworkError(_ error: Error, _ completion: Completion) {
        let restClientError: RestClientError
        switch (error as NSError).code {
            case NSURLErrorNotConnectedToInternet: restClientError = .notConnectedToInternet
            case NSURLErrorCancelled: restClientError = .cancelled
            default: restClientError = .networkError(error)
        }
        completion(nil, restClientError)
    }

    private func handle(httpResponse: HTTPURLResponse,
                        data: Data?,
                        completion: @escaping Completion) {
        if Constant.httpStatusCodeErrorRange ~= httpResponse.statusCode {
            let restClientError: RestClientError = .httpError(data: data, statusCode: httpResponse.statusCode)
            completion(data, restClientError)
        } else {
            completion(data, nil)
        }
    }

}

extension RestClientImpl {

    enum Constant {
        static let httpStatusCodeErrorRange = 400..<600
    }

}

enum RestClientError: Error {

    case cancelled
    case notConnectedToInternet
    case networkError(Error)
    case httpError(data: Data?, statusCode: Int)

}

