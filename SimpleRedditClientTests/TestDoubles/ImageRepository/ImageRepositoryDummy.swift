//
//  ImageRepositoryDummy.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 08.11.2020.
//

import Foundation
@testable import SimpleRedditClient

final class ImageRepositoryDummy: ImageRepository {

    func fetchImage(by url: URL, completion: @escaping FetchImageCompletion) -> CancellationToken? {
        return nil
    }

}
