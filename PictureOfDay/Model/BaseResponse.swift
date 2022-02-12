//
//  File.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation
enum Error : Swift.Error,Equatable {
    case invalidRequest
    case invalidData
    case error(errorMessge:String)
}
struct BaseResponse : Codable,Equatable {
    var date: String
    var title: String
    var explanation: String
    var url: String
    var media_type: String
    
    init(date:String,title: String,explanation: String,url: String,media_type: String) {
        
        self.date = date
        self.title = title
        self.explanation = explanation
        self.url = url
        self.media_type = media_type
    }
}
