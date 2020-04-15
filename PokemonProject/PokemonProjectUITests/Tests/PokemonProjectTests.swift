//
//  PokemonProjectTests.swift
//  PokemonProjectUITests
//
//  Created by Mariana V. A. Souza on 15/04/20.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

class PokemonProjectTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        PokemonListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionDidLoad() {
        waitElementExists(element: PokemonListScreen.visiblePokemonCell())
    }
    
    func testDetails() {
        let cell = PokemonListScreen.visiblePokemonCell()
        waitElementExists(element: cell, scrollElement: PokemonListScreen.screen, timeout: 2)
        cell.tap()
        PokemonScreen.waitScreen(testCase: self)
        PokemonScreen.tapNavigationBackButton()
        PokemonListScreen.waitScreen(testCase: self)
    }
    
    func testCollectionRefresh() {
        let cell = PokemonListScreen.visiblePokemonCell()
        let screen = PokemonListScreen.screen
        
        let start = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2.5))
        start.press(forDuration: 0, thenDragTo: finish)
        
        waitElementExists(element: cell, scrollElement: screen)
    }
}

