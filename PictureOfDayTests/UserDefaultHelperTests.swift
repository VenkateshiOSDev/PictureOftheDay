//
//  File.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//


import XCTest
@testable import PictureOfDay
class UserDefaultHelperTests: XCTestCase {
    func test_wishListIsEmpty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        XCTAssertNil(sut.wishList)
    }
    
    func test_wish_CatchEmpty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        XCTAssertNil(sut.catchInfo)
    }
    
    func test_wishListIs_NotEmpty(){
        var sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut.wishList = [BaseResponse(date: "",
                                     title: "",
                                     explanation: "", url: "", media_type: "")]
        XCTAssertNotNil(sut.wishList)
    }
    
    func test_CatchIS_NotEmpty(){
        var sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut.catchInfo = CatchValues(synchdate:"",
                                    catchInfo: BaseResponse(date: "",
                                                            title: "",
                                                            explanation: "",
                                                            url: "",
                                                            media_type: ""))
        XCTAssertNotNil(sut.catchInfo)
    }
    
    func test_wishList_Set_CatchInfo(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut._set(value: [], key: .catchInfo)
        XCTAssertNotNil(sut.catchInfo)
    }
    
    
    func test_wishList_Set_IsNotEmpty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut._set(value: [], key: .wishList)
        XCTAssertNotNil(sut.wishList)
    }
    
    
    func test_RemoveCatchInfo_WithEmpty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut.deleteObjectInUD(key: .catchInfo)
        XCTAssertNil(sut.catchInfo)
    }
    
    
    func test_Remove_WishList_ISEmpty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut.deleteObjectInUD(key: .wishList)
        XCTAssertNil(sut.wishList)
    }
    
    func test_resetAllUserDefaultst_Empty(){
        let sut : UserDefaultHelperProtocol = UserDefaultHelperSpy()
        sut.resetAllUserDefaults()
        XCTAssertNil(sut.wishList)
        XCTAssertNil(sut.catchInfo)
    }
    
    
    class UserDefaultHelperSpy : UserDefaultHelperProtocol {
        func _set(value: Any?, key: Defaults) {
            if key == .catchInfo {
                catchInfo =  CatchValues(synchdate:"",
                                         catchInfo: BaseResponse(date: "",
                                                                 title: "",
                                                                 explanation: "",
                                                                 url: "",
                                                                 media_type: ""))
            }else{
                wishList = [BaseResponse(date: "",
                                         title: "",
                                         explanation: "", url: "", media_type: "")]
            }
        }
        
        func _get(valueForKay key: Defaults) -> Any? {
            if key == .catchInfo {
                return catchInfo
            }else{
                return wishList
            }
        }
        
        func deleteObjectInUD(key: Defaults) {
            if key == .catchInfo {
                catchInfo = nil
            }else{
                wishList = nil
            }
        }
        
        func resetAllUserDefaults() {
            wishList = nil
            catchInfo = nil
            
        }
        
        var catchInfo: CatchValues?
        
        var wishList: [BaseResponse]?
        
        
    }
}
