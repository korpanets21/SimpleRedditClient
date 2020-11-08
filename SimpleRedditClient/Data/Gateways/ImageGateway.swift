//
//  ImageGateway.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import Foundation

protocol ImageGateway {

    typealias DownloadImageCompletion = (_ result: Result<Data, Error>) -> Void

    func downloadImage(by url: URL, completion: @escaping DownloadImageCompletion) -> CancellationToken?

}

final class ImageGatewayImpl: ImageGateway {

    private let restClient: RestClient

    init(_ restClient: RestClient) {
        self.restClient = restClient
    }

    func downloadImage(by url: URL, completion: @escaping DownloadImageCompletion) -> CancellationToken? {
        return restClient.downloadData(at: url) { [weak self] result in
            switch result {
            case .success(let url):
                do {
                    let imageData = try Data(contentsOf: url)
                    self?.dispatch(completion: completion, with: .success(imageData))
                } catch {
                    self?.dispatch(completion: completion, with: .failure(error))
                }
            case .failure(let error):
                self?.dispatch(completion: completion, with: .failure(error))
            }
        }
    }

    private func dispatch(completion: @escaping DownloadImageCompletion,
                                        with result: Result<Data, Error>) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

}
