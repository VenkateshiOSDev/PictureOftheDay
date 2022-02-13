//
//  HomeViewModel.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject{
    func viewDidload()
    func fetchPictureOfTheDay(date:Date,loadFromCacheIfFails:Bool)
    var updateViewOnSucess : ((BaseResponse,String)->Void)? { get set }
    var updateViewOnFailure : ((String)->Void)? { get set }
    var dateFormat:String {get}
    var apiKey:String {get}
    var onFvaroite : Bool{get}
    func onTapOnFavroite()
    var dataResponce : BaseResponse? {get}
}
class HomeViewModel : HomeViewModelProtocol {
    var updateViewOnSucess : ((BaseResponse,String)->Void)? = { _,_ in }
    var updateViewOnFailure : ((String)->Void)?  = { _ in }
    private let catchRequired:Bool
    var apiKey:String
    var dateFormat:String
    var dataResponce : BaseResponse?
    var onFvaroite : Bool{
        get {
            return UserDefaultHelper().wishList?.contains(where: {$0.date == dataResponce?.date ?? ""}) == true
        }
    }
    init(catchRequired:Bool,apiKey:String,dateFormat:String){
        self.catchRequired = catchRequired
        self.apiKey = apiKey
        self.dateFormat = dateFormat
    }
    
    func viewDidload(){
        fetchPictureOfTheDay(date:Date(), loadFromCacheIfFails: true)
    }
    
    func fetchPictureOfTheDay(date:Date,loadFromCacheIfFails:Bool){
        let dateStr = date.string(format: dateFormat)
        NetworkManager.makeApiCall(request: .Home(date: dateStr, apiKey: apiKey), resultType: BaseResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if self.catchRequired {
                    UserDefaultHelper().catchInfo = CatchValues(synchdate: dateStr,
                                                                catchInfo: data)
                }
                self.dataResponce = data
                self.updateViewOnSucess?(data,dateStr)
                break
            case .failure(_):
               
                if let catchInfo = UserDefaultHelper().catchInfo, loadFromCacheIfFails ,let catchData = catchInfo.catchInfo{
                    self.dataResponce = catchData
                    self.updateViewOnSucess?(catchData,catchInfo.synchdate)
                }else{
                    self.dataResponce = nil
                    self.updateViewOnFailure?("No data available for date: \(dateStr) \n Please Pick Another Day")
                }
                break
            }
        }
    }
    func onTapOnFavroite(){
        var wishList = UserDefaultHelper().wishList == nil ? [] :  UserDefaultHelper().wishList
        if onFvaroite {
            wishList?.removeAll(where:({$0.date == dataResponce?.date}))
        }else{
            if let dataResponce = dataResponce {
                wishList?.insert(dataResponce, at: 0)
            }
        }
        UserDefaultHelper().wishList = wishList
    }
}
