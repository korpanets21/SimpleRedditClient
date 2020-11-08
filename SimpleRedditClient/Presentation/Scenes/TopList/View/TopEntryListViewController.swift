//
//  TopEntryListViewController.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import UIKit

class TopEntryListViewController: UIViewController {

    var presenter: TopEntryListPresenter?

    @IBOutlet private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, TopEntryViewModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        setupTableView()
        setupDataSource()
    }

    private func setupTableView() {
        tableView.registerCellNibs(for: [TopEntryTableViewCell.self])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { (table, indexPath, vm) -> UITableViewCell? in
                                                    let cell = table.dequeueCell(of: TopEntryTableViewCell.self, for: indexPath)
                                                    cell.configure(with: vm)
                                                    return cell
                                                   })
    }

}

extension TopEntryListViewController: TopEntryListView {

    func show(items: [TopEntryViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TopEntryViewModel>()
        snapshot.appendSections([.topEntries])
        snapshot.appendItems(items, toSection: .topEntries)
        dataSource?.apply(snapshot)
    }

    func showAlertWith(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension TopEntryListViewController {

    enum Section {
        case topEntries
    }
}

