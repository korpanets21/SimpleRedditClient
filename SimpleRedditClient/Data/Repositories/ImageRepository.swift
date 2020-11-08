//
//  ImageRepository.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import Foundation

protocol ImageRepository {

    typealias FetchImageCompletion = (_ result: Result<Data, Error>) -> Void

    func fetchImage(by url: URL, completion: @escaping FetchImageCompletion) -> CancellationToken?
}

final class ImageRepositoryImpl: ImageRepository {

    private let gateway: ImageGateway
    private let cache = NSCache<NSString, NSData>()

    init(_ gateway: ImageGateway) {
        self.gateway = gateway
    }

    func fetchImage(by url: URL, completion: @escaping FetchImageCompletion) -> CancellationToken? {
        if let data = cache.object(forKey: makeCacheKey(for: url)) {
            completion(.success(data as Data))
            return nil
        } else {
            return downloadImage(by: url, completion: completion)
        }
    }

    private func downloadImage(by url: URL, completion: @escaping FetchImageCompletion) -> CancellationToken? {
        return gateway.downloadImage(by: url) { [weak self] result in
            switch result {
            case .success(let data):
                if let self = self {
                    let key = self.makeCacheKey(for: url)
                    self.cache.setObject(data as NSData, forKey: key)
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func makeCacheKey(for url: URL) -> NSString {
        return url.absoluteString as NSString
    }

}
