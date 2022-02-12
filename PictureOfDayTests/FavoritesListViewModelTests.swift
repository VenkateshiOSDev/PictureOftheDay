//
//  File.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation
import XCTest
@testable import PictureOfDay
class FavoritesListViewModelTests: XCTestCase {
    
    func test_checkFor_WithoutViewWillAppear(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        XCTAssertEqual(sut.itemsCount(), 0)
    }
    
    func test_checkFor_WithViewWillAppear(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        sut.viewWillAppear()
        XCTAssertEqual(sut.itemsCount(), 2)
    }
    
    func test_checkFor_RemoveCache(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        sut.viewWillAppear()
        sut.removeFromCatche(at: 0)
        XCTAssertEqual(sut.itemsCount(), 1)
    }
    
    func test_checkFor_CacheInfo(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        sut.viewWillAppear()
        sut.removeFromCatche(at: 0)
        XCTAssertEqual(sut.item(at: 0).media_type, "image")
        XCTAssertEqual(sut.item(at: 0).title, "2")
        XCTAssertEqual(sut.item(at: 0).explanation, "2")
        XCTAssertEqual(sut.item(at: 0).url, "2")
        XCTAssertEqual(sut.item(at: 0).date, "2")
    }
    
    func test_removeAndcheckFor_CacheInfo(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        sut.viewWillAppear()
        sut.removeFromCatche(at: 1)
        XCTAssertEqual(sut.item(at: 0).media_type, "video")
        XCTAssertEqual(sut.item(at: 0).title, "1")
        XCTAssertEqual(sut.item(at: 0).explanation, "1")
        XCTAssertEqual(sut.item(at: 0).url, "1")
        XCTAssertEqual(sut.item(at: 0).date, "1")
    }
    
    func test_SuccessCallback_CacheInfo(){
        let sut : FavoritesListViewModelProtocol = FavoritesListViewModelSpy()
        
        var resultFetched = false
        let exp = expectation(description: "Wait for load completion")
        sut.updateViewOnSucess = { [weak self] in
            if self == nil { return}
            resultFetched =  true
            exp.fulfill()
        }
        sut.viewWillAppear()
        
        wait(for: [exp], timeout: 5.0)
        XCTAssertTrue(resultFetched)
    }
    
    func test_checkMemoryLeackage_CacheInfo(){
        var sut : FavoritesListViewModelProtocol? = FavoritesListViewModelSpy()
        
        var resultFetched = false
        sut?.updateViewOnSucess = { [weak self] in
            if self == nil { return}
            resultFetched =  true
        }
        sut?.viewWillAppear()
        sut = nil
        XCTAssertFalse(resultFetched)
    }
    
    internal class FavoritesListViewModelSpy:FavoritesListViewModelProtocol{
        var updateViewOnSucess: (() -> Void)?  = { }
        
        var favRoutesList = [BaseResponse]()
        func viewWillAppear() {
            fetchCatchList()
        }
        
        func fetchCatchList() {
            favRoutesList = [BaseResponse(date: "1",
                                          title: "1",
                                          explanation: "1",
                                          url: "1",
                                          media_type: "video"),
                             BaseResponse(date: "2",
                                          title: "2",
                                          explanation: "2",
                                          url: "2",
                                          media_type: "image")]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.updateViewOnSucess?()
            }
            
        }
        
        func removeFromCatche(at: Int) {
            favRoutesList.remove(at: at)
        }
        
        func itemsCount() -> Int {
            favRoutesList.count
        }
        
        func item(at index: Int) -> BaseResponse {
            favRoutesList[index]
        }
        
        
    }
}
