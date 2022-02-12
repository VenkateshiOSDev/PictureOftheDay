//
//  File.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//
import XCTest
@testable import PictureOfDay
class FavListVCTests : XCTestCase{
    func test_favListVC_NotNill(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()

        XCTAssertNotNil(sut)
    }
    
    func test_favListVC_title(){
        let sut = makeSUT()
        
        XCTAssertEqual(sut?.title,"Favorites")
    }
    
    func test_tablview_Rows(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)

        XCTAssertEqual(sut?.tblList.numberOfRows(inSection: 0),sut?.viewModel.itemsCount())
    }
    
    func test_tablview_Rows_whenItemDeleted(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        sut?.tableView( (sut?.tblList)!, commit: .delete, forRowAt: IndexPath(item: 0, section: 0))

        XCTAssertEqual(sut?.tblList.numberOfRows(inSection: 0),sut?.viewModel.itemsCount())
    }
    
    func test_tablviewCell_Nill(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        sut?.removeFromCatch(at: 0)
        sut?.removeFromCatch(at: 0)
        
        let cell = sut?.tblList.cellForRow(at: IndexPath(row: 0, section: 0)) as? FavListCell
        
        XCTAssertNil(cell)
    }
    
    func test_tablviewCell_NotNill(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        
        let cell = sut?.tblList.cellForRow(at: IndexPath(row: 0, section: 0)) as? FavListCell
        XCTAssertNotNil(cell)
    }
    
    
    func test_tablviewCell_whenItemFetched(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        
        let cell = sut?.tblList.cellForRow(at: IndexPath(row: 0, section: 0)) as? FavListCell
        
        XCTAssertEqual(cell?.lblTitle.text,sut?.viewModel.item(at: 0).title)
        XCTAssertEqual(cell?.lblDescription.text,sut?.viewModel.item(at: 0).explanation)
        XCTAssertFalse(cell?.webView.isHidden ?? true)
        XCTAssertTrue(cell?.imgViewMedia.isHidden ?? false)
    }
    
    func test_tablview_Rows_whenAllItemsDeleted(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        sut?.tableView( (sut?.tblList)!, commit: .delete, forRowAt: IndexPath(item: 0, section: 0))
        sut?.tableView( (sut?.tblList)!, commit: .delete, forRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(sut?.tblList.numberOfRows(inSection: 0),0)
    }
    
    func test_tablview_Rows_whenUserNonDeletedOperations(){
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.setupViewModel(view_Model: FavoritesListViewModelSpy())
        sut?.viewWillAppear(true)
        sut?.tableView( (sut?.tblList)!, commit: .insert, forRowAt: IndexPath(item: 0, section: 0))
        sut?.tableView( (sut?.tblList)!, commit: .none, forRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(sut?.tblList.numberOfRows(inSection: 0),2)
    }
    
    
    
    private func makeSUT()->FavoritesListVC?{
        let bundle = Bundle(for: FavoritesListVC.self)
        let vc = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "FavoritesListVC") as? FavoritesListVC
        vc?.title = "Favorites"
        
        return vc
        
    }
    
    class FavoritesListViewModelSpy:FavoritesListViewModelProtocol{
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
            updateViewOnSucess?()
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
