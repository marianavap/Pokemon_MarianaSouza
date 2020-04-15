//
//  URLSession+Extensions.swift
//  PokemonProject
//
//  Created by Mariana V. A. Souza on 29/05/19.
//  Copyright © 2019 Mariana. All rights reserved.
//


import Foundation

// MARK: - URLSession
extension URLSession: BaseURLSession {
    /// Data task to load
     ///
     /// - Parameters:
     ///   - url: url
     ///   - completionHandler: completionHandler
    
    
    func postFavorite(from url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
         dataTask(with: url) { (data, urlResponse, error) in
               completionHandler(data, urlResponse, error)
               }.resume()
    }
    
    func getDetailValues(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, urlResponse, error) in
        completionHandler(data, urlResponse, error)
        }.resume()
    }
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, urlResponse, error)
            }.resume()
    }
}
