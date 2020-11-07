//
//  TopEntryListViewController.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import UIKit

class TopEntryListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TopEntryListViewController: TopEntryListView {

    func show(items: [TopEntryViewModel]) {
    }

    func showAlertWith(message: String) {
    }
}

