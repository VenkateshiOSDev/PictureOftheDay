//
//  RequestRouterTest.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import XCTest
@testable import PictureOfDay
class RequestRouterTests: XCTestCase {
    func test_checkBaseURL(){
        let sut = makeHome_Sut()
        XCTAssertNotNil(sut.fullUrlStr)
        XCTAssertNotNil(sut.httpMethod)
        XCTAssertNotNil(sut.asRequest)
    }
    
    func test_Validate_Url(){
        let sut = makeHome_Sut()
        XCTAssertEqual(sut.httpMethod,"GET")
        XCTAssertEqual(sut.fullUrlStr,Constants.BaseURL + sut.subUrl)
    }

    func test_Validate_Method(){
        let sut = makeHome_Sut()
        XCTAssertEqual(sut.httpMethod,"GET")
    }
    
    func test_Validate_DateInsideURL(){
        let sut = makeHome_Sut()
        XCTAssertTrue(sut.subUrl.contains("yyyy-MM-dd"))
    }
    //helper:-
    private func makeHome_Sut()->RequestRouter{
        return RequestRouter.Home(date: "yyyy-MM-dd", apiKey: Constants.ApiKey)
    }
}
