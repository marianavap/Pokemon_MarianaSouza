//
//  UITableView+Extensions.swift
//  PokemonProject
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    /// Dequeues identifiable cell
    ///
    /// - Parameters:
    ///   - viewType: Cell class type
    ///   - indexPath: indexPath
    /// - Returns: Typed cell
    func dequeueReusableCell<T>(viewType: T.Type, for indexPath: IndexPath) -> T where T: Identifiable & UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Invalid cell type: \(String(describing: T.self))")
        }
        return cell
    }
}
