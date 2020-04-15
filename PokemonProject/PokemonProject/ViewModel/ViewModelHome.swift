//
//  ViewModel.swift
//  PokemonProject
//
//  Created by MarianaSouza on 3/12/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation

/// Delegate to comunicate with controller
protocol ListControllerDelegate: class {
    /// Called when the list is updated
    ///
    /// - Parameter viewModel: ListViewModel
    func listViewModelWasFetch(_ viewModel: ViewModelHome)
    
    /// Called when some error happen
    ///
    /// - Parameters:
    ///   - viewModel: ListViewModel
    ///   - error: Error
    func listViewModel(_ viewModel: ViewModelHome, threw error: Error)
}

class ViewModelHome {
    weak var delegate: ListControllerDelegate?
    private var service: BaseServiceProtocol
    private var startIndex: Int = 0
    private var fetchCompleted = false
    private var isFetching = false
    private var error = false
    private(set) var values: [FirstCellViewModel] = []
    
    init(appService: BaseServiceProtocol = BaseProvider()) {
        self.service = appService
    }
    
    func refresh() {
        startIndex = 0
        fetchCompleted = false
    }
    
    enum CellType {
        case value(FirstCellViewModel)
        case loading
    }
    
    func numberOfItens() -> Int {
        return values.count
    }
    
    func cellType(at indexPath: IndexPath) -> CellType {
        if indexPath.row > values.count - 1 {
            return .loading
        }
        
        return .value(values[indexPath.row])
    }
    
    func didSelectedRow(at indexPath: IndexPath) -> FirstCellViewModel {
        return values[indexPath.row]
    }
}

extension ViewModelHome {
    func fetch(refresh: Bool = false) {
        
        guard (!fetchCompleted && !isFetching) || !isFetching else {
            return
        }
                
        if refresh {
            self.refresh()
        }
        
        startIndex += 1
        error = false
        isFetching = true
                
        service.getValues(startIndex: startIndex) { [weak self] (callback) in
            guard let weakSelf = self else { return }
            do {
                let allList = try callback()
                        
                if refresh {
                    weakSelf.values = []
                }
                
                if allList.results.isEmpty {
                    weakSelf.fetchCompleted = true
                } else {
                    weakSelf.values.append(contentsOf: allList.results.map({ (value) -> FirstCellViewModel in
                        FirstCellViewModel(value)
                    }))
                }
                        
                weakSelf.delegate?.listViewModelWasFetch(weakSelf)
            } catch {
                weakSelf.delegate?.listViewModel(weakSelf, threw: error)
                weakSelf.error = true
                weakSelf.startIndex -= 1
                weakSelf.delegate?.listViewModelWasFetch(weakSelf)
            }
            weakSelf.isFetching = false
        }
    }
}
