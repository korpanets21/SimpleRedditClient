//
//  TopEntryListViewController.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import UIKit

class TopEntryListViewController: UIViewController {

    var presenter: TopEntryListPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }

}

extension TopEntryListViewController: TopEntryListView {

    func show(items: [TopEntryViewModel]) {
    }

    func showAlertWith(message: String) {
    }
}

