//
//  TopEntryListPresenter.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TopEntryViewModel, rhs: TopEntryViewModel) -> Bool {
        return lhs.id == rhs.id
    }

}

final class TopEntryListPresenterImpl: TopEntryListPresenter {

    weak var view: TopEntryListView?

    private let gateway: TopEntryGateway
    private lazy var authorInfoFormatter = TopEntryAuthorInfoFormatter()
    private var topEntries: [TopEntry] = []

    init(_ gateway: TopEntryGateway) {
        self.gateway = gateway
    }

    func viewLoaded() {
        gateway.fetch(completion: { [weak self] result in
            self?.handle(result)
        })
    }

    func refresh(completion: @escaping RefreshCompletion) {
        gateway.fetch { [weak self] result in
            self?.topEntries = []
            self?.handle(result)
            completion()
        }
    }

    func willDisplayItem(_ viewModel: TopEntryViewModel) {
        guard viewModel.id == topEntries[topEntries.count - 3].id else { return }
        gateway.fetchMore { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: Result<[TopEntry], Error>) {
        switch result {
        case .success(let topEntries):
            self.topEntries += topEntries
            show(items: self.topEntries)
        case .failure(let error):
            show(error: error)
        }
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
