//
//  EarthImageryAPI.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

enum EarthImageryError: Error {
    case couldNotParseDate
}

class EarthImageryAPI: API {
    static let sharedInstance = EarthImageryAPI()
    let apiKey = "26tHAEXDULv5VOdDgzHgQtUnpK3gCDniLeEV8dV6"
    
    func getEarthImage(lat: Double, long: Double, asset: EarthAsset, completion: @escaping (EarthImage?, Error?) -> Void) {
        guard let dateStr = asset.date.split(separator: "T").first else {
            completion(nil, EarthImageryError.couldNotParseDate)
            return
        }
        
        let queryItems = [
            "lon": "\(long)",
            "lat": "\(lat)",
            "date": String(describing: dateStr),
            "api_key": apiKey
        ]
        
        self.request("https://api.nasa.gov/planetary/earth/imagery", queryItems: queryItems) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let parsedData = try decoder.decode(EarthImage.self, from: data)
                    DispatchQueue.main.async {
                        completion(parsedData, nil)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        completion(nil, e)
                    }
                }
            }
        }
    }
    
    func getAssetList(lat: Double, long: Double, completion: @escaping ([EarthAsset]?, Error?) -> Void) {
        let queryItems = [
            "lon": "\(long)",
            "lat": "\(lat)",
            "api_key": apiKey
        ]
        
        self.request("https://api.nasa.gov/planetary/earth/assets", queryItems: queryItems) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let parsedData = try decoder.decode(EarthAssetList.self, from: data)
                    completion(parsedData.results, nil)
                } catch (let e) {
                    DispatchQueue.main.async {
                        completion(nil, e)
                    }
                }
            }
        }
    }
}
