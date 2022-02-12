//
//  HomeViewModelTests.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import XCTest
@testable import PictureOfDay
class HomeViewModelTests: XCTestCase {

    func test_viewModelWithExclodeViewDidLoad(){
        let sut = HomeViewModel(catchRequired: false,
                                apiKey: Constants.ApiKey,
                                dateFormat: Constants.dateFormat)
        var captureResult = [Bool]()
        sut.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
        }
        
        sut.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
        }
        XCTAssertEqual(captureResult,[])
    }
    
    func test_viewModelWithViewDidLoad(){
        let sut = HomeViewModel(catchRequired: false,
                                apiKey: Constants.ApiKey,
                                dateFormat: Constants.dateFormat)
        var captureResult = [Bool]()
        let exp = expectation(description: "Wait for load completion")
        sut.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            exp.fulfill()
        }
        
        sut.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            exp.fulfill()
        }
        sut.viewDidload()
        wait(for: [exp], timeout: 5)
        XCTAssertEqual(captureResult,[true])
    }
    
    func test_viewModelWithInvalidKey(){
        let sut = HomeViewModel(catchRequired: false,
                                apiKey: "",
                                dateFormat: Constants.dateFormat)
        var captureResult = [Bool]()
        let exp = expectation(description: "Wait for load completion")
        sut.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            exp.fulfill()
        }

        sut.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            exp.fulfill()
        }
        sut.viewDidload()
        wait(for: [exp], timeout: 10.0)
        XCTAssertEqual(captureResult,[false])
    }

    func test_viewModelWithInvalidFormat(){
        let sut = HomeViewModel(catchRequired: false,
                                apiKey: Constants.ApiKey,
                                dateFormat: "dd-yyyy-mm")
        var captureResult = [Bool]()
        let exp = expectation(description: "Wait for load completion")
        sut.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            exp.fulfill()
        }

        sut.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            exp.fulfill()
        }
        sut.viewDidload()
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(captureResult,[false])
    }

    func test_viewModelWithInvalidFormatAndApikey(){
        let sut = HomeViewModel(catchRequired: false,
                                apiKey: "",
                                dateFormat: "dd-yyyy-mm")
        var captureResult = [Bool]()
        let exp = expectation(description: "Wait for load completion")
        sut.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            exp.fulfill()
        }

        sut.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            exp.fulfill()
        }
        sut.viewDidload()
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(captureResult,[false])
    }
    
    func test_viewModelWithInvalidMomoryLeakage(){
        var sut :HomeViewModelProtocol? = HomeViewModelSpy()
        var captureResult = [Bool]()
        sut?.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            
        }

        sut?.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            
        }
        sut?.viewDidload()
        sut = nil
        XCTAssertEqual(captureResult,[])
    }
    
    func test_onAddTapFavrouite(){
        let sut :HomeViewModelProtocol? = HomeViewModelSpy()
        var captureResult = [Bool]()
        sut?.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            
        }

        sut?.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            
        }
        sut?.viewDidload()
        sut?.onTapOnFavroite()
        XCTAssertEqual(sut?.onFvaroite,true)
    }
    
    func test_onRemoveTapFavrouite(){
        let sut :HomeViewModelProtocol? = HomeViewModelSpy()
        var captureResult = [Bool]()
        sut?.updateViewOnSucess = { [weak self] (res,lastSynch) in
            if self == nil { return }
            captureResult.append(true)
            
        }

        sut?.updateViewOnFailure = { [weak self] (error) in
            if self == nil { return }
            captureResult.append(false)
            
        }
        sut?.viewDidload()
        sut?.onTapOnFavroite()
        sut?.onTapOnFavroite()
        XCTAssertEqual(sut?.onFvaroite,false)
    }
    
    class HomeViewModelSpy  : HomeViewModelProtocol{
        var onFvaroite: Bool = false
        
        func onTapOnFavroite() {
            onFvaroite = !onFvaroite
        }
        
        var dateFormat: String = ""
        
        var apiKey: String = ""
        
        func viewDidload() {
            fetchPictureOfTheDay(date: Date())
        }
        
        func fetchPictureOfTheDay(date: Date) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.updateViewOnSucess?(BaseResponse(date: "",
                                                       title: "",
                                                       explanation: "", url: "", media_type: ""),
                                          "2021,12,22")
                self?.updateViewOnFailure?(Error.invalidData)
            }
            
        }
        
        var updateViewOnSucess: ((BaseResponse,String) -> Void)?
        
        var updateViewOnFailure: ((Error) -> Void)?
        
        
    }
}

