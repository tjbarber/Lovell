//
//  API.swift
//  Lovell
//
//  Created by TJ Barber on 9/20/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

enum APIError: Error {
    case cannotCreateUrl
}

class API {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    private func generateURL(_ urlStr: String, queryItems: [String: String]?) -> URL? {
        guard var components = URLComponents(string: urlStr) else {
            // Cannot create URLComponents object
            return nil
        }
        
        var queryItemsArray = [URLQueryItem]()
        
        if let queryItems = queryItems {
            for (key, value) in queryItems {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItemsArray.append(queryItem)
            }
        }
        
        components.queryItems = queryItemsArray
        guard let url = components.url else {
            // Cannot get URL from component object.
            return nil
        }
        
        return url
    }

    func request(_ urlStr: String, queryItems: [String: String]?, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = generateURL(urlStr, queryItems: queryItems) else {
            completion(nil, APIError.cannotCreateUrl)
            return
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
    
    func downloadFile(_ urlStr: String, queryItems: [String: String]?, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = generateURL(urlStr, queryItems: queryItems) else {
            completion(nil, APIError.cannotCreateUrl)
            return
        }
        let downloadTask = session.downloadTask(with: url) { location, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let location = location {
                do {
                    let data = try Data(contentsOf: location)
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        completion(nil, e)
                    }
                }
                
            }
        }
        downloadTask.resume()
    }
}
