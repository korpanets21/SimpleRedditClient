//
//  TableView+Extensions.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import UIKit

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
        return cell
    }

    func registerCellNibs(for classes: [AnyClass]) {
        classes.map({ String(describing: $0)}).forEach {
            register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
    }

}
