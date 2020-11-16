//
//  TopEntryListViewController.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 05.11.2020.
//

import UIKit

protocol TopEntryListPresenter {

    typealias RefreshCompletion = () -> Void

    func viewLoaded()
    func refresh()
    func willDisplayItem(_ viewModel: TopEntryViewModel)

}

class TopEntryListViewController: UIViewController {

    var presenter: TopEntryListPresenter?

    @IBOutlet private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, TopEntryViewModel>?
    private lazy var refreshControl = self.makeRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        setupTableView()
        setupDataSource()
    }

    private func setupTableView() {
        tableView.registerCellNibs(for: [TopEntryTableViewCell.self])
        tableView.delegate = self
        tableView.refreshControl = refreshControl
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { (table, indexPath, vm) -> UITableViewCell? in
                                                    let cell = table.dequeueCell(of: TopEntryTableViewCell.self, for: indexPath)
                                                    cell.configure(with: vm)
                                                    return cell
                                                   })
    }

    private func makeRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return control
    }

    @objc private func refreshAction() {
        presenter?.refresh()
    }

}

extension TopEntryListViewController: TopEntryListView {

    func show(items: [TopEntryViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TopEntryViewModel>()
        snapshot.appendSections([.topEntries])
        snapshot.appendItems(items, toSection: .topEntries)
        dataSource?.apply(snapshot)

        //TODO: Move to separate method that will be called by presenter. Add tests
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

    func replace(oldItem: TopEntryViewModel, with newItem: TopEntryViewModel) {
        if var snapshot = dataSource?.snapshot() {
            snapshot.insertItems([newItem], beforeItem: oldItem)
            snapshot.deleteItems([oldItem])
            dataSource?.apply(snapshot)
        }
    }

    func showAlertWith(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension TopEntryListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let viewModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        presenter?.willDisplayItem(viewModel)
    }

}

extension TopEntryListViewController {

    enum Section {
        case topEntries
    }
}

