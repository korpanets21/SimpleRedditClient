//
//  TopEntryListViewDummy.swift
//  SimpleRedditClientTests
//
//  Created by Taras Korpanets on 07.11.2020.
//

@testable import SimpleRedditClient

final class TopEntryListViewDummy: TopEntryListView {

    func show(items: [TopEntryViewModel]) { }
    func replace(oldItem: TopEntryViewModel, with newItem: TopEntryViewModel) { }
    func showAlertWith(message: String) { }

}
