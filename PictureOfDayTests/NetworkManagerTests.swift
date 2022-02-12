//
//  File.swift
//  PictureOfDayTests
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import XCTest
@testable import PictureOfDay
class NetworkManagerTests: XCTestCase {

    func test_check_WromgURl_withError(){
        var captureResult = [Result<BaseResponse,Error>]()
        makeSUT(request:RequestRouter.Home(date: "yyy mm 22", apiKey: Constants.ApiKey)) { result in
            captureResult.append(result)
        }
        XCTAssertEqual(captureResult,[.failure(Error.invalidRequest)])
    }
    
    func test_check_WromgURl_withErrorCount(){
        var captureResult = [Result<BaseResponse,Error>]()
        makeSUT(request:RequestRouter.Home(date: "yyy mm 22", apiKey: Constants.ApiKey)) { result in
            captureResult.append(result)
        }
        XCTAssertEqual(captureResult.count,1)
    }
    
    func test_check_WromgURl_withInvalidKey(){
        var captureResult = [Result<BaseResponse,Error>]()
        makeSUT(request:RequestRouter.Home(date: "yyy/mm/22", apiKey: " ")) { result in
            captureResult.append(result)
        }
        XCTAssertEqual(captureResult.count,1)
    }
    
    func test_check_withInvalidDateFormat(){
        var captureResult = [Result<BaseResponse,Error>]()
        let exp = expectation(description: "Wait for load completion")
        makeSUT(request:RequestRouter.Home(date: "12/02/22", apiKey: Constants.ApiKey)) { result in
            captureResult.append(result)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(captureResult,[.failure(.invalidData)])
    }
    
    func test_check_withvalidDateFormat(){
        var captureResult : BaseResponse?
        let exp = expectation(description: "Wait for load completion")
        makeSUT(request:RequestRouter.Home(date: "2021-02-22", apiKey: Constants.ApiKey)) { result in
            switch result {
            case .success(let res):
                captureResult = res
            case .failure(_):
                break
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(captureResult?.date,"2021-02-22")
    }
    
    // Helper :-
    
    private func makeSUT(request : RequestRouter,
                         callback: @escaping(Result<BaseResponse,Error>)-> Void){
        NetworkManager.makeApiCall(request: request,
                                   resultType: BaseResponse.self,
                                   completionHandler: callback)
    }
}
