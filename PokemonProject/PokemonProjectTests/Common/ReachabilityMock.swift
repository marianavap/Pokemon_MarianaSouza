//
//  ReachabilityMock.swift
//  PokemonProjectTests
//
//  Created by Mariana V. A. Souza on 15/04/20.
//  Copyright © 2019 Mariana. All rights reserved.
//

@testable import PokemonProject

class ReachabilityMock: BaseReachability {
    private var reachable: Bool
    
    init(reachable: Bool = true) {
        self.reachable = reachable
    }
    
    var internetIsReachable: Bool {
        return reachable
    }
}
