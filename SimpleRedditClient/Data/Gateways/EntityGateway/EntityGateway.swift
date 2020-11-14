//
//  EntityGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 07.11.2020.
//

import Foundation

enum WebConfiguration: String {

    case develop = "https://www.reddit.com"

    var baseURL: String {
        return rawValue
    }
}

class EntityGateway {

    typealias ResponseCompletion<T: Decodable> = (Result<T, Error>) -> Void
    typealias BuilderClosure = (URLRequestBuilder) -> ()

    let restClient: RestClient
    let configuration: WebConfiguration

    init(_ restClient: RestClient, configuration: WebConfiguration = .develop) {
        self.restClient = restClient
        self.configuration = configuration
    }

    func perform<T>(_ builderClosure: BuilderClosure, completion: @escaping ResponseCompletion<T>) -> CancellationToken? {
        let url = URL(string: configuration.baseURL)!
        let builder = URLRequestBuilder(baseURL: url)
        builderClosure(builder)
        guard let urlRequest = builder.urlRequest else {
            completion(.failure(EntityGatewayError.failedToBuildURLRequest))
            return nil
        }
        return perform(urlRequest, completion: completion)
    }

    private func perform<T>(_ request: URLRequest, completion: @escaping ResponseCompletion<T>) -> CancellationToken? {
        return restClient.perform(request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let aData = try self.check(data)
                    let response: T = try self.map(aData)
                    self.dispatch(completion: completion, with: .success(response))
                } catch {
                    self.dispatch(completion: completion, with: .failure(error))
                }
            case .failure(let error):
                self.dispatch(completion: completion, with: .failure(error))
            }
        }
    }

    private func dispatch<T: Decodable>(completion: @escaping ResponseCompletion<T>,
                                        with result: Result<T, Error>) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

    private func handle(_ error: RestClientError?) throws {
        if let error = error {
            throw EntityGatewayError(restClientError: error)
        }
    }

    private func check(_ data: Data?) throws -> Data {
        guard let data = data, data.count > 0 else {
            throw EntityGatewayError.noData
        }
        return data
    }

    private func map<T: Decodable>(_ json: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(T.self, from: json)
        } catch {
            throw EntityGatewayError.mappingFailed
        }
    }

}

enum EntityGatewayError: Error {
    case failedToBuildURLRequest
    case noData
    case mappingFailed
    case notConnectedToInternet
    case cancelled
    case networkError(Error)
    case httpError(data: Data?, statusCode: Int)
    case webServerError(errorData: Data, statusCode: Int)
    case unauthorized
}

extension EntityGatewayError {

    init(restClientError: RestClientError) {
        switch restClientError {
            case .notConnectedToInternet: self = .notConnectedToInternet
            case .cancelled: self = .cancelled
            case .networkError(let error): self = .networkError(error)
            case .httpError(let data, let statusCode):
                if statusCode == 401 {
                    self = .unauthorized
                } else if let data = data {
                    self = .webServerError(errorData: data, statusCode: statusCode)
                } else {
                    self = .httpError(data: data, statusCode: statusCode)
                }
        }
    }

}
