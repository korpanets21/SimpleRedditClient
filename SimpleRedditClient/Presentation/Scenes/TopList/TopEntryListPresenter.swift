//
//  TopEntryListPresenter.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

protocol TopEntryListPresenter {

    func viewLoaded()

}

protocol TopEntryListView: AnyObject {

    func show(items: [TopEntryViewModel])
    func showAlertWith(message: String)

}

struct TopEntryViewModel: Hashable {

    let id: String
    let title: String
    let info: String
    // To avoid UIKit import, other possible option is to hide UIKit using protocol
    // or give up and import it)
    let thumbnail: Data?
    let commentsCount: String

}

final class TopListPresenterImpl: TopEntryListPresenter {

    private let gateway: TopEntryGateway
    weak var view: TopEntryListView?
    private lazy var authorInfoFormatter = TopEntryAuthorInfoFormatter()

    init(_ gateway: TopEntryGateway) {
        self.gateway = gateway
    }

    func viewLoaded() {
        gateway.fetchMore(completion: { [weak self] result in
            switch result {
            case .success(let topEntries):
                self?.show(items: topEntries)
            case .failure(let error):
                self?.show(error: error)
            }
        })
    }

    private func show(error: Error) {
        let message = ErrorFormatter().string(for: error)
        view?.showAlertWith(message: message)
    }

    private func show(items: [TopEntry]) {
        let viewModels = items.map({ makeViewModel(for: $0) })
        view?.show(items: viewModels)
    }

    private func makeViewModel(for entry: TopEntry) -> TopEntryViewModel {
        return TopEntryViewModel(id: entry.id,
                                 title: entry.title,
                                 info: authorInfoFormatter.infoString(for: entry),
                                 thumbnail: nil,
                                 commentsCount: String(entry.commentsCount))
    }

}
