//
//  File.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation
class Archive{
    static func archive<T:Codable>(w:T) -> Data? {
           let encoder = JSONEncoder()
           let data = try? encoder.encode(w)
           return data
    }
    static func unarchive<T:Codable>(d:Data,codable:T.Type) -> T? {
        let decoder = JSONDecoder()
        let data = try? decoder.decode(T.self, from: d)
        return data
    }
}
