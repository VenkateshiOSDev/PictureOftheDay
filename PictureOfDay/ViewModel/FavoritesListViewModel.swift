//
//  FavoritesListViewModel.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation
protocol FavoritesListViewModelProtocol: AnyObject{
    func viewWillAppear()
    func fetchCatchList()
    var updateViewOnSucess : (()->Void)? {get set}
    func removeFromCatche(at:Int)
    func itemsCount()->Int
    func item(at index:Int)->BaseResponse
}
class FavoritesListViewModel : FavoritesListViewModelProtocol {
    var updateViewOnSucess : (()->Void)? = {  }
    private var dataSource : [BaseResponse] = []
    private let helper : UserDefaultHelper?
    init(helper : UserDefaultHelper){
        self.helper = helper
    }
    func viewWillAppear(){
        fetchCatchList()
    }
    
    func fetchCatchList(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.dataSource = self.helper?.wishList ?? []
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateViewOnSucess?()
            }
        }
    }
    
    func removeFromCatche(at:Int){
        dataSource.remove(at:at)
        UserDefaultHelper().wishList = dataSource
    }
    
    func itemsCount() -> Int {
        return dataSource.count
    }
    
    func item(at index: Int) -> BaseResponse {
        return dataSource[index]
    }
    
}
