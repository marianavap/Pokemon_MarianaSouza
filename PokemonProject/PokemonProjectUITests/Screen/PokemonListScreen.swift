//
//  PokemonListScreen.swift
//  PokemonProjectUITests
//
//  Created by Mariana V. A. Souza on 15/04/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import XCTest

class PokemonListScreen: BaseScreen {
    private struct ElementsIds {
        static let visiblePokemonLoadText = "LabelCell"
        static let notVisiblePokemonLoadText = "X"
    }
    
    static var screen: XCUIElement {
        return XCUIApplication().tables["PokemonListScreen"]
    }
    
    static func visiblePokemonCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.visiblePokemonLoadText).firstMatch
    }
    
    static func notVisiblePokemonCell() -> XCUIElement {
        return screen.cells.containing(.staticText, identifier: ElementsIds.notVisiblePokemonLoadText).firstMatch
    }
}
