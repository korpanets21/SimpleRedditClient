//
//  UIStoryboard+Extensions.swift
//  SimpleRedditClient
//
//  Created by Taras Korpanets on 08.11.2020.
//

import UIKit

extension UIStoryboard {

    enum Storyboard: String {
        case main = "Main"
        case launch = "LaunchScreen"
    }

    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        let identifier = String(describing: T.self)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(identifier)")
        }
        return viewController
    }

}

