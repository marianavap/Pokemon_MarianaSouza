//
//  ViewController.swift
//  PokemonProject
//
//  Created by MarianaSouza on 3/12/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UITableViewController {
    private var listViewModel = ViewModelHome()
  
    private lazy var arefreshControl: UIRefreshControl = {
              let refreshControl = UIRefreshControl()
              refreshControl.addTarget(self,
                                       action: #selector(refresh),
                                       for: UIControl.Event.valueChanged)
              refreshControl.tintColor = .silver
              return refreshControl
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listViewModel.delegate = self
        tableView.refreshControl = arefreshControl

        listViewModel.fetch(refresh: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ListViewCell,
            let controller = segue.destination as? DetailViewController {
            controller.urlValue(cell.viewModel)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listViewModel.numberOfItens()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = listViewModel.cellType(at: indexPath)
        switch cellType {
        case .value(let firstCellViewModel):
            let cell = tableView.dequeueReusableCell(viewType: ListViewCell.self, for: indexPath)
            cell.setup(value: firstCellViewModel)
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(viewType: LoadingViewCell.self, for: indexPath)
            listViewModel.fetch()
            cell.setup()
            return cell
        }
    }
}

// MARK: - PokemonListViewModelDelegate
extension HomeViewController: ListControllerDelegate {
    func listViewModel(_ viewModel: ViewModelHome, threw error: Error) {
         HandleError.handle(error: error)
    }
    
    func listViewModelWasFetch(_ viewModel: ViewModelHome) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.arefreshControl.isRefreshing {
                self.arefreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - Private methods
   private extension HomeViewController {
       @objc private func refresh() {
           listViewModel.fetch(refresh: true)
       }
   }

