//
//  File.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import Foundation

class NetworkManager {
   static func makeApiCall<T:Decodable>(request: RequestRouter, resultType: T.Type, completionHandler:@escaping(Result<T,Error>)-> Void)
    {
        guard let request = request.asRequest else {
            completionHandler(.failure(Error.invalidRequest))
            return
        }
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                do {
                    debugPrint("API Success")
                    let result = try JSONDecoder().decode(T.self, from: responseData!)
                    completionHandler(.success(result))
                }
                catch let error {
                    debugPrint("API error occured while decoding = \(error.localizedDescription)")

                    completionHandler(.failure(Error.invalidData))
                }
            }else {
                debugPrint("API Failed")
                let errorMessage = error?.localizedDescription ?? ""
                completionHandler(.failure(Error.error(errorMessge: errorMessage)))
            }
            
        }.resume()
    }
}
