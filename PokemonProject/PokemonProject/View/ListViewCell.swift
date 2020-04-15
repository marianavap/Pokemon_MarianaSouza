//
//  ListViewCell.swift
//  PokemonProject
//
//  Created by MarianaSouza on 3/13/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation
import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    private(set) var viewModel: FirstCellViewModel!
    
    override func awakeFromNib() {
        super .awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Auxiliar methods
extension ListViewCell {
    func setup(value: FirstCellViewModel) {
        viewModel = value
        name.text = value.name
    }
}

// MARK: - Identifiable
extension ListViewCell: Identifiable {}
