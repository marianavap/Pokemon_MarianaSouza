//
//  ShowInView.swift
//  imagegalleryapp
//
//  Created by Mariana V. A. Souza on 30/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

struct MainList: Codable {
   let results: [Result]
}
// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}
