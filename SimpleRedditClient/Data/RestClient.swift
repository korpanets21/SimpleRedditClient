//
//  RestClient.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

protocol RestClient {

    typealias RequestCompletion = (_ result: Result<Data?, RestClientError>) -> Void
    typealias DownloadRequestCompletion = (_ result: Result<URL, RestClientError>) -> Void

    func perform(_ request: URLRequest, _ completion: @escaping RequestCompletion) -> CancellationToken
    func downloadData(at url: URL, completion: @escaping DownloadRequestCompletion) -> CancellationToken

}

class RestClientImpl: RestClient {

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()

    func perform(_ request: URLRequest, _ completion: @escaping RequestCompletion) -> CancellationToken {
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                try self.handleNetworkError(error)
                try self.handle(response: response, data: data)
                completion(.success(data))
            } catch {
                completion(.failure(error as! RestClientError))
            }
        }
        task.resume()
        return task
    }

    func downloadData(at url: URL, completion: @escaping DownloadRequestCompletion) -> CancellationToken {
        let task = session.downloadTask(with: url) { (url, response, error) in
            do {
                try self.handleNetworkError(error)
                try self.handle(response: response, data: nil)
                completion(.success(url!))
            } catch {
                completion(.failure(error as! RestClientError))
            }
        }
        task.resume()
        return task
    }

    private func handleNetworkError(_ error: Error?) throws {
        guard let error = error else { return }
        let restClientError: RestClientError
        switch (error as NSError).code {
            case NSURLErrorNotConnectedToInternet: restClientError = .notConnectedToInternet
            case NSURLErrorCancelled: restClientError = .cancelled
            default: restClientError = .networkError(error)
        }
        throw restClientError
    }

    private func handle(response: URLResponse?,
                        data: Data?) throws {
        if let httpResponse = response as? HTTPURLResponse,
           Constant.httpStatusCodeErrorRange ~= httpResponse.statusCode {
            throw RestClientError.httpError(data: data, statusCode: httpResponse.statusCode)
        }
    }

}

extension RestClientImpl {

    enum Constant {
        static let httpStatusCodeErrorRange = 400..<600
    }

}

extension URLSessionTask: CancellationToken { }

enum RestClientError: Error {

    case cancelled
    case notConnectedToInternet
    case networkError(Error)
    case httpError(data: Data?, statusCode: Int)

}

