//
//  RequestRouter.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation

struct HTTPMethods{
    static let get = "GET"
}
enum RequestRouter {
    case Home(date: String,apiKey:String)
    var subUrl : String
    {
        get{
            switch self {
            case .Home(let date,let apiKey):
                return "planetary/apod?api_key=\(apiKey)&date=\(date)"
            }
        }
    }
    var fullUrlStr : String
    {
        get{
            switch self {
            case .Home:
                return Constants.BaseURL + subUrl
            }
        }
    }
    var httpMethod : String
    {
        get{
            switch self {
            case .Home:
                return HTTPMethods.get
            }
        }
    }
    
    var asRequest : URLRequest?
    {
        get{
            switch self {
            case .Home:
                if let url = URL(string: fullUrlStr) {
                    var request = URLRequest(url: url)
                    request.httpMethod = httpMethod
                    return request
                }else{
                    return nil
                }
                
            }
        }
    }
}
