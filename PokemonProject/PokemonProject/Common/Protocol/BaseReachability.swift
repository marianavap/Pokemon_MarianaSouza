//
//  BaseReachability.swift
//  PokemonProject
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

protocol BaseReachability {
    
    /// True if internet is available
    var internetIsReachable: Bool { get }
}
