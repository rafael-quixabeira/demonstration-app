//
//  UITableView+Extensions.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 11/05/25.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as? T else {
            fatalError("could not dequeue cell with identifier: \(String(describing: cellType))")
        }

        return cell
    }
}
