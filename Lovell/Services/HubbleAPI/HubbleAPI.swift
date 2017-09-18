//
//  HubbleAPI.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

class HubbleAPI {
    static let sharedInstance = HubbleAPI()
    private init() {}
    
    func getImageData(page: Int, completion: @escaping ([HubbleImageMetadata]?, Error?) -> Void) {
        self.request("http://hubblesite.org/api/v3/images/all", queryItems: ["page": String(page)]) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                // FIXME: - More error handling
                do {
                    let hubbleImageData = try decoder.decode([HubbleImageMetadata].self, from: data)
                    DispatchQueue.main.async {
                        completion(hubbleImageData, nil)
                    }
                } catch (let e) {
                    // FIXME: - So much error handling
                    fatalError(e.localizedDescription)
                }
            }
        }
    }
    
    func request(_ urlStr: String, queryItems: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard var components = URLComponents(string: urlStr) else {
            // FIXME: - Handle error here
            fatalError("Cannot create URLComponents object")
        }
        
        var queryItemsArray = [URLQueryItem]()
        
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItemsArray.append(queryItem)
        }
        
        components.queryItems = queryItemsArray
        guard let url = components.url else {
            // FIXME: - Handle error here
            fatalError("Cannot get URL from component object.")
        }
    
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                   completion(nil, error)
                }
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        
        dataTask.resume()
    }
}
