//
//  FavoritesListVC.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import UIKit

class FavoritesListVC: UIViewController {
    @IBOutlet weak var tblList : UITableView!
    var viewModel : FavoritesListViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.register(UINib(nibName: "FavListCell", bundle: nil), forCellReuseIdentifier: "FavListCell")
       setupViewModel(view_Model: FavoritesListViewModel(helper: UserDefaultHelper()))
        // Do any additional setup after loading the view.
    }
    
    func setupViewModel(view_Model:FavoritesListViewModelProtocol){
        self.viewModel = view_Model
        self.viewModel.updateViewOnSucess = { [weak self] in
            guard let self = self else { return }
            self.tblList.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }


}
extension FavoritesListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "FavListCell", for: indexPath) as? FavListCell else {
            return UITableViewCell()
        }
        cell.setupData(for: viewModel.item(at:indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            removeFromCatch(at: indexPath.row)
        } else if editingStyle == .insert {
            
        }
    }
    
    func removeFromCatch(at index:Int){
        viewModel.removeFromCatche(at: index)
        tblList.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}
