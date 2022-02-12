//
//  UserDefaultHelper.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation
public enum Defaults: String {
   case wishList = "wishList"
   case catchInfo = "catchInfo"

}
protocol UserDefaultHelperProtocol {
    var catchInfo: CatchValues? { get set }
    var wishList: [BaseResponse]? { get set }
    func _set(value: Any?, key: Defaults)
    func _get(valueForKay key: Defaults)-> Any?
    func deleteObjectInUD(key:Defaults)
    func resetAllUserDefaults()
}
struct CatchValues : Codable {
    let synchdate: String
    let catchInfo: BaseResponse?
}
final class UserDefaultHelper: UserDefaultHelperProtocol {
    
    var catchInfo: CatchValues? {
        set {
            if let data = Archive.archive(w: newValue) {
                _set(value: data, key: .catchInfo)
            }
        } get {
            if let data = _get(valueForKay: .catchInfo) as? Data,
                let info = Archive.unarchive(d: data, codable: CatchValues.self){
                return  info
            }
            return nil
        }
    }
    
    
    var wishList: [BaseResponse]? {
        set {
            if let data = Archive.archive(w: newValue) {
                _set(value: data, key: .wishList)
            }
        } get {
            if let data = _get(valueForKay: .wishList) as? Data,
                let info = Archive.unarchive(d: data, codable: [BaseResponse].self){
                return  info
            }
            return nil
        }
    }
    
    func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func _get(valueForKay key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    
    func deleteObjectInUD(key:Defaults)
    {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func resetAllUserDefaults(){
        let defaults = UserDefaults.standard
           let dictionary = defaults.dictionaryRepresentation()
           dictionary.keys.forEach { key in
               defaults.removeObject(forKey: key)
           }
    }
}

