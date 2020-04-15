//
//  ViewModelDetail.swift
//  PokemonProject
//
//  Created by DetailViewController on 4/10/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation

/// Delegate to comunicate with controller
protocol DetailListControllerDelegate: class {
    /// Called when the list is updated
    ///
    /// - Parameter viewModel: ListViewModel
    func detaillistViewModelWasFetch(_ viewModel: ViewModelDetail)
    
    /// Called when some error happen
    ///
    /// - Parameters:
    ///   - viewModel: ListViewModel
    ///   - error: Error
    func detaillistViewModel(_ viewModel: ViewModelDetail, threw error: Error)
}

class ViewModelDetail {
    weak var delegate: DetailListControllerDelegate?
    private var service: DetailServiceProtocol
    private var startIndex: Int = 0
    private var fetchCompleted = false
    private var isFetching = false
    private var error = false
    
    private(set) var values : DetailValues?
    private(set) var abilities : [Ability] = []
    private(set) var gameIndices : [Game] = []
    private(set) var sprites : Sprite?
    private(set) var stats : [Stats] = []
    private(set) var type : [Type] = []
    private(set) var objectArray = [FormatedObjects]()
    private(set) var compile : [String: [VersionClass]]?
   
    struct Constants {
        static let name : String =  "Name: "
        static let number : String =  "Number: "
        static let height : String =  "Height: "
        static let weight : String =  "Weight: "
        static let empty : String =  "is empty"
        static let abilities : String =  "Abilities"
        static let game : String =  "Game"
        static let stats : String =  "Stats"
        static let type : String =  "Type"
    }
    
    init(appService: DetailServiceProtocol = BaseProvider()) {
        self.service = appService

    }
    
    func refresh() {
        startIndex = 0
        fetchCompleted = false
    }
    
    func numberOfItens() -> Int {
        return self.abilities.count
    }
    
    func name() ->  String {
        guard let name = self.values else { return Constants.empty }
        return Constants.name + name.name
    }
    
    func number() ->  String {
        guard let number = self.values else { return Constants.empty }
        return  Constants.number + "\(number.number)"
    }
    
    func height() ->  String {
        guard let height = self.values else { return Constants.empty }
        return  Constants.height + "\(height.height)"
    }
    
    func weight() ->  String {
        guard let weight = self.values else { return Constants.empty }
        return  Constants.weight + "\(weight.weight)"
    }
    
    func urlImage() ->  String {
        guard let url = self.sprites else { return Constants.empty }
        return url.frontDefault
    }

    func organizeCompila() {
        self.compile = [String: [VersionClass]]()

        var aabilities = [VersionClass]()
        var agameIndices = [VersionClass]()
        var astats = [VersionClass]()
        var atype = [VersionClass]()

        for item in self.abilities {
            guard let value = item.abilities else { return }
            aabilities.append(contentsOf: value)
        }
        
        for item in self.gameIndices {
            agameIndices = [VersionClass]()
            
            guard let value = item.version else { return }
            agameIndices.append(contentsOf: value)
        }
        
        for item in self.stats {
            astats = [VersionClass]()
                       
            guard let value = item.allStat else { return }
            astats.append(contentsOf: value)
        }
        
        for item in self.type {
            atype = [VersionClass]()
                       
            guard let value = item.alltype else { return }
            atype.append(contentsOf: value)
        }
        
        self.compile?[Constants.abilities] = aabilities
        self.compile?[Constants.game] = agameIndices
        self.compile?[Constants.stats] = astats
        self.compile?[Constants.type] = atype
        
        guard let allvalue = self.compile else { return }
              
        for (key, value) in allvalue {
            self.objectArray.append(FormatedObjects(sectionName: key, sectionObjects: value))
        }
    }
    
    func section() -> Int {
        guard let value = self.compile else { return 0 }
        return (value.keys.count)
    }
    
    func titleForHeaderInSection(section: Int) -> String?  {
        return self.objectArray[section].sectionName
    }
    
    func numberOfSections() -> Int {
         return self.objectArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return self.objectArray[section].sectionObjects.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> VersionClass {
        return self.objectArray[indexPath.section].sectionObjects[indexPath.row]
    }
}

extension ViewModelDetail {
    func fetchDetail(urlID: String) {
        guard (!fetchCompleted && !isFetching) || !isFetching else {
            return
        }
        
        startIndex += 1
        error = false
        isFetching = true
                        
        guard let url = URL(string: urlID) else { return }
        
        service.getDetailValues(urlID: url) { [weak self] (callback) in
            guard let weakSelf = self else { return }
            do {
                let allList = try callback()
            
                for item in allList.abilities {
                    weakSelf.abilities.append(contentsOf: [item].map ({ (abilities) -> Ability in
                        Ability (ability: item)
                    }))
                }
                
                for item in allList.gameIndices {
                    weakSelf.gameIndices.append(contentsOf: [item].map({ (gameIndices) -> Game in
                        Game(game: item)
                    }))
                }
                
                for item in allList.stats {
                    weakSelf.stats.append(contentsOf: [item].map({ (stats) -> Stats in
                        Stats(stat: item)
                    }))
                }
                
                for item in allList.types {
                    weakSelf.type.append(contentsOf: [item].map({ (type) -> Type in
                        Type(type: item)
                    }))
                }
                
                weakSelf.sprites = Sprite(sprite: allList.sprites)

                weakSelf.values = DetailValues(name: allList.name, number: allList.order, height: allList.height, weight: allList.weight)
                weakSelf.organizeCompila()
                weakSelf.delegate?.detaillistViewModelWasFetch(weakSelf)
            } catch {
                weakSelf.delegate?.detaillistViewModel(weakSelf, threw: error)
                weakSelf.error = true
                weakSelf.startIndex -= 1
                weakSelf.delegate?.detaillistViewModelWasFetch(weakSelf)
            }
            weakSelf.isFetching = false
        }
    }
}
