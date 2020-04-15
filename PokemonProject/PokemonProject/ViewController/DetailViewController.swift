//
//  DetailViewController.swift
//  PokemonProject
//
//  Created by MarianaSouza on 4/10/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct Constants {
            static let unfavoriteimage: String = "unfavorite"
            static let favoriteimage : String =  "favorite"
            static let cell : String =  "Cell"
        }
        
        private var firstModel: FirstCellViewModel?
        private var listDetailViewModel = ViewModelDetail()
        private var secondViewModel = DetailValues()
        private var sprite = Sprite()
        private var favoriteViewModel = FavoriteViewModel()

         
        @IBOutlet weak var name: UILabel!
        @IBOutlet weak var imageItem: UIImageView!
        @IBOutlet weak var number: UILabel!
        @IBOutlet weak var height: UILabel!
        @IBOutlet weak var weight: UILabel!
        private var stringValue: String?

        @IBOutlet weak var tableView: UITableView!
        
        override func viewDidLoad() {
            super .viewDidLoad()
            
            guard let fileUrL = firstModel else { return }
            
            listDetailViewModel.delegate = self
            listDetailViewModel.fetchDetail(urlID: fileUrL.url)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super .viewWillAppear(animated)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listDetailViewModel.numberOfRowsInSection(section: section)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return listDetailViewModel.numberOfSections()
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return listDetailViewModel.titleForHeaderInSection(section: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell : UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell)
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cell)
            }
            
            cell.textLabel?.text = listDetailViewModel.cellForRowAt(indexPath: indexPath).name
            cell.detailTextLabel?.text = listDetailViewModel.cellForRowAt(indexPath: indexPath).url
            
            return cell
        }
        
        @IBOutlet weak var favorite: UIButton? {
            didSet {
                let filtered = SectionCache.sharedInstance.allItem
                
                favorite?.isSelected = false
                favorite?.setBackgroundImage(UIImage(imageLiteralResourceName : Constants.unfavoriteimage), for: .normal)
                   
                if filtered.count != 0 {
                    for (key, _) in filtered {
                        guard let model = self.firstModel else { return }

                        if key == model.name {
                            favorite?.isSelected = true
                            favorite?.setBackgroundImage(UIImage(imageLiteralResourceName : Constants.favoriteimage), for: .normal)
                        }
                    }
                } else {
                    favorite?.isSelected = false
                    favorite?.setBackgroundImage(UIImage (imageLiteralResourceName: Constants.unfavoriteimage), for: .normal)
                }
            }
        }
    }

    // MARK: - PokemonListViewModelDelegate
    extension DetailViewController: FavControllerDelegate {
        func postFavWasFetch() {
            DispatchQueue.main.async {
                if self.favorite?.isSelected == false {
                    self.favorite?.isSelected = true
                    self.favorite?.setBackgroundImage(UIImage(imageLiteralResourceName : Constants.favoriteimage), for: .normal)
                } else {
                    self.favorite?.isSelected = false
                    self.favorite?.setBackgroundImage(UIImage(imageLiteralResourceName : Constants.unfavoriteimage), for: .normal)
                }
            }
        }
        
        @IBAction func favoriteButton (sender: UIButton) {
            guard let model = self.firstModel else { return }
            SectionCache.sharedInstance.allItem[model.name] = model.url
            self.stringValue = SectionCache.sharedInstance.allItem.description
            
            guard let stringValue = self.stringValue else { return }
            
            self.favoriteViewModel.delegate = self
            self.favoriteViewModel.post(string: stringValue)
           }
    }

    // MARK: - Auxiliar methods
    extension DetailViewController {
        func urlValue(_ viewModel: FirstCellViewModel) {
            firstModel = viewModel
        }
    }

    // MARK: - Auxiliar methods
    extension DetailViewController {
        func setup(value: Sprite) {
            sprite = value
            imageItem.setImage(with: value.frontDefault)
        }
    }

    // MARK: - PokemonListViewModelDelegate
    extension DetailViewController: DetailListControllerDelegate {
        func detaillistViewModelWasFetch(_ viewModel: ViewModelDetail) {
            self.listDetailViewModel = viewModel
            
            DispatchQueue.main.async {
                self.imageItem.setImage(with: self.listDetailViewModel.urlImage())
                self.name.text = self.listDetailViewModel.name()
                self.number.text = self.listDetailViewModel.number()
                self.height.text = self.listDetailViewModel.height()
                self.weight.text = self.listDetailViewModel.weight()
                
                self.tableView .reloadData()
            }
        }
        
        func detaillistViewModel(_ viewModel: ViewModelDetail, threw error: Error) {
             HandleError.handle(error: error)
        }
    }



