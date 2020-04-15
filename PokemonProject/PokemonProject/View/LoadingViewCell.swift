//
//  LoadingViewCell.swift
//  PokemonProject
//
//  Created by MarianaSouza on 3/13/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}

// MARK: - Auxiliar methods
extension LoadingViewCell {
    func setup() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .silver
    }
   
    func noIndicator () {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
}

// MARK: - Identifiable
extension LoadingViewCell: Identifiable {}
