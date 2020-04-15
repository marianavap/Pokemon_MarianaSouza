//
//  FavoriteViewModel.swift
//  PokemonProject
//
//  Created by DetailViewController on 4/14/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//


import Foundation

/// Delegate to comunicate with controller
protocol FavControllerDelegate: class {
    func postFavWasFetch()
}

class FavoriteViewModel {
    weak var delegate: FavControllerDelegate?
    private var postService: PostFavoriteProtocol?
    private var response: String?
   
    init(appService: PostFavoriteProtocol = BaseProvider()) {
        self.postService = appService
    }

    func post(string: String) {
           postService?.post(postString: string) { [weak self] (callback) in
               
            guard let weakSelf = self else { return }
            do {
                let result = try callback()
                weakSelf.response = result
                weakSelf.delegate?.postFavWasFetch()
               } catch {
                    
               }
           }
       }
    
}

