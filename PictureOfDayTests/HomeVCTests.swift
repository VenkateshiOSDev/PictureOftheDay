//
//  HomeVCTests.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import XCTest
@testable import PictureOfDay
class HomeVCTestsTests: XCTestCase {
    
    func test_HomeVc_NotNil() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        
        XCTAssertNotNil(sut)
    }
    
    func test_feedView_hasTitle() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        
        XCTAssertEqual(sut?.title, "Title")
    }
    
    func test_HomeVcViewModel_NotNil() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        
        XCTAssertNotNil(sut?.viewModel)
        XCTAssertNotNil(sut?.viewModel?.updateViewOnSucess)
        XCTAssertNotNil(sut?.viewModel?.updateViewOnFailure)
    }

    
    func test_IntoTitle_WithHomeResponce() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.updateView(with:BaseResponse(date:"",
                                          title: "Header Title",
                                          explanation: "explanation",
                                          url: "",
                                          media_type: ""),
                        lastSynchdate: "2021/02/12")
        XCTAssertEqual(sut?.lblTitle.text, "Header Title")
        XCTAssertEqual(sut?.lblLastUpdated.text,"Last updated information for " + "2021/02/12")
        XCTAssertEqual(sut?.txtDescription.text, "explanation")
    }
    
    func test_DatePickerDat_WithHomeResponce() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.updateView(with:BaseResponse(date:"",
                                          title: "Header Title",
                                          explanation: "explanation",
                                          url: "",
                                          media_type: ""),
                        lastSynchdate: "2021/02/12")
        XCTAssertEqual(sut?.viewModel?.dateFormat, Constants.dateFormat)
        XCTAssertEqual(sut?.viewModel?.apiKey, Constants.ApiKey)
        XCTAssertEqual(sut?.indicator.isAnimating, false)
    }
    
    func test_Indicator_WithErrorHomeResponce() {
        let sut = makeSUT()
        sut?.loadViewIfNeeded()
        sut?.updateViewOnFailure(error: "Error")
        wait(for: 1)
        XCTAssertEqual(sut?.indicator.isAnimating, false)
    }
    
    func test_ViewDidLoad_WithHomeResponce() {
        let sut = makeSUT()
        sut?.loadViewIfNeeded()
        wait(for: 1)
        XCTAssertNotEqual(sut?.lblTitle.text, "")
    }
    func test_LoaderStarted_WithHomeResponce() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        XCTAssertEqual(sut?.indicator.isAnimating, true)
    }
    
    func test_APIKey_Formatter() {
        let sut = makeSUT()
        sut?.loadViewIfNeeded()
        XCTAssertEqual(sut?.txtDatePicker.text, Date().string(format: sut?.viewModel?.dateFormat ?? ""))
    }
    
    func test_HomeVcViewModel_CheckForMemory() {
        var sut = makeSUT()
        sut?.loadViewIfNeeded()
        wait(for: 1)
        sut = nil
        wait(for: 3)
        XCTAssertNil(sut?.viewModel)
        XCTAssertNil(sut?.viewModel?.updateViewOnSucess)
        XCTAssertNil(sut?.viewModel?.updateViewOnFailure)
    }
    
    
    func test_MediaTypeVideo_WithHomeResponce() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.updateView(with:BaseResponse(date:"",
                                          title: "Header Title",
                                          explanation: "explanation",
                                          url: "",
                                          media_type: "video"),
                        lastSynchdate: "2021/02/12")
        XCTAssertNil(sut?.imgViewMedia)
    }
    
    func test_MediaTypeImage_WithHomeResponce() {
        let sut = makeSUT()
        
        sut?.loadViewIfNeeded()
        sut?.updateView(with:BaseResponse(date:"",
                                          title: "Header Title",
                                          explanation: "explanation",
                                          url: "",
                                          media_type: "image"),
                        lastSynchdate: "2021/02/12")
        wait(for: 1)
        XCTAssertNotNil(sut?.imgViewMedia)
    }
    
    private func makeSUT()->HomeVC?{
        let bundle = Bundle(for: HomeVC.self)
        let vc = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        vc?.title = "Title"
        
        return vc
        
    }
    
    internal class HomeViewModelSPy : HomeViewModelProtocol{
        func viewDidload(date: Date) {
            
        }
        
        func fetchPictureOfTheDay(date: Date, loadFromCacheIfFails: Bool) {
            
        }
        
        var updateViewOnFailure: ((String) -> Void)?
        
        var dataResponce: BaseResponse?
       
        var updateViewOnSucess: ((BaseResponse, String) -> Void)? = { _,_ in}
        var dateFormat: String = ""
        var apiKey: String = ""
        var onFvaroite: Bool = false
        func onTapOnFavroite() {
            onFvaroite = !onFvaroite
        }
    }
}
extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
