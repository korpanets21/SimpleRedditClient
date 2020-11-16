//
//  TopEntryListPresenter.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import Foundation

protocol TopEntryListView: AnyObject {

    func show(items: [TopEntryViewModel])
    func replace(oldItem: TopEntryViewModel, with newItem: TopEntryViewModel)
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
        hasher.combine(thumbnail)
    }

    static func == (lhs: TopEntryViewModel, rhs: TopEntryViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.thumbnail == rhs.thumbnail
    }

}

final class TopEntryListPresenterImpl: TopEntryListPresenter {

    weak var view: TopEntryListView?

    private let interactor: FetchTopEntriesInteractorInput
    private let imageRepository: ImageRepository
    private lazy var authorInfoFormatter = TopEntryAuthorInfoFormatter()
    private var topEntries: [TopEntry] = []
    private var isRefreshing = false

    init(_ interactor: FetchTopEntriesInteractorInput, _ imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        self.interactor = interactor
    }

    func viewLoaded() {
        interactor.fetch()
    }

    func refresh() {
        isRefreshing = true
        interactor.fetch()
    }

    func willDisplayItem(_ viewModel: TopEntryViewModel) {
        guard viewModel.id == topEntries[topEntries.count - 3].id else {
            return
        }
        interactor.fetchMore()
    }

    private func show(error: Error) {
        let message = ErrorFormatter().string(for: error)
        view?.showAlertWith(message: message)
    }

    private func show(items: [TopEntry]) {
        let viewModels = items.map({ makeViewModel(for: $0) })
        view?.show(items: viewModels)
    }

    private func makeViewModel(for entry: TopEntry, with imageData: Data? = nil) -> TopEntryViewModel {
        return TopEntryViewModel(id: entry.id,
                                 title: entry.title,
                                 info: authorInfoFormatter.infoString(for: entry),
                                 thumbnail: imageData,
                                 commentsCount: String(entry.commentsCount))
    }

    private func resetIsRefreshing() {
        isRefreshing = false
    }

}

extension TopEntryListPresenterImpl: FetchTopEntriesInteractorOutput {

    func didFetchTopEntries(_ topEntries: [TopEntry]) {
        if isRefreshing {
            self.topEntries = topEntries
            resetIsRefreshing()
        } else {
            self.topEntries += topEntries
        }
        show(items: self.topEntries)
    }

    func failedToFetchTopEntries(with error: Error) {
        show(error: error)
        resetIsRefreshing()
    }

}
