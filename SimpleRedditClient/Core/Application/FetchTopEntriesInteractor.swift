//
//  FetchTopEntriesInteractor.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 15.11.2020.
//

import Foundation

protocol FetchTopEntriesInteractorInput {

    func fetch()
    func fetchMore()

}

protocol FetchTopEntriesInteractorOutput: AnyObject {

    func didFetchTopEntries(_ topEntries: [TopEntry])
    func failedToFetchTopEntries(with error: Error)

}

final class FetchTopEntriesInteractor: FetchTopEntriesInteractorInput {

    weak var output: FetchTopEntriesInteractorOutput?

    private let gateway: TopEntryGateway
    private weak var cancellationToken: CancellationToken?

    init(_ gateway: TopEntryGateway) {
        self.gateway = gateway
    }

    func fetch() {
        cancellationToken?.cancel()
        cancellationToken = gateway.fetch(completion: { [weak self] result in
            self?.completeFetch(with: result)
        })
    }

    func fetchMore() {
        guard cancellationToken == nil else { return }
        cancellationToken = gateway.fetchMore(completion: { [weak self] result in
            self?.completeFetch(with: result)
        })
    }

    private func completeFetch(with result: Result<[TopEntry], Error>) {
        handleFetchResult(result)
        clearCancellationToken()
    }

    private func handleFetchResult(_ result: Result<[TopEntry], Error>) {
        switch result {
        case .success(let entries):
            output?.didFetchTopEntries(entries)
        case .failure(let error):
            output?.failedToFetchTopEntries(with: error)
        }
    }

    private func clearCancellationToken() {
        self.cancellationToken = nil
    }

}
