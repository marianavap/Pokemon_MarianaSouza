//
//  FirstCellViewModel.swift
//  PokemonProject
//
//  Created by DetailViewController on 4/9/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation

struct FirstCellViewModel {
    private(set) var name: String = String()
    private(set) var url: String = String()
}

extension FirstCellViewModel {
    init(_ value: Result) {
        name = value.name
        url = value.url
    }
}
