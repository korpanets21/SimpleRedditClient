//
//  URLRequestBuilder.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import Foundation

final class URLRequestBuilder {

    var baseURL: URL
    var path: String = ""
    var queryItems: [String: String]?
    var httpMethod: HTTPMethod = .GET
    var httpHeaders: [String: String]?

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = httpHeaders
        return request
    }

    private var url: URL? {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { return nil }
        components.path = path
        components.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }

}

extension URLRequestBuilder {

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

}
