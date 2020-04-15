//
//  PokemonScreen.swift
//  PokemonProjectUITests
//
//  Created by Mariana V. A. Souza on 15/04/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import XCTest

class PokemonScreen: BaseScreen {
    static var screen: XCUIElement {
        return XCUIApplication().otherElements["PokemonScreen"]
    }
}
