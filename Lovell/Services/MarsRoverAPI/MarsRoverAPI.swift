//
//  MarsRoverAPI.swift
//  Lovell
//
//  Created by TJ Barber on 9/20/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

enum MarsRover: String {
    case curiosity
    case opportunity
    case spirit
}

enum MarsRoverCamera: String {
    case fhaz
    case rhaz
    case mast
    case chemcam
    case mahli
    case navcam
    case pancam
    case minites
}

class MarsRoverAPI: API {
    static let sharedInstance = MarsRoverAPI()
    let apiKey = "26tHAEXDULv5VOdDgzHgQtUnpK3gCDniLeEV8dV6"
    override private init() {}
    
    func getImageMetadataFrom(_ vehicle: MarsRover, camera: MarsRoverCamera, sol: Int, completion: @escaping ([MarsRoverImageMetadata]?, Error?) -> ()) {
        let queryParameters = [
            "sol": String(sol),
            "camera": camera.rawValue,
            "api_key": self.apiKey
        ]
        request("https://api.nasa.gov/mars-photos/api/v1/rovers/\(vehicle.rawValue)/photos", queryItems: queryParameters) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let parsedData = try decoder.decode([String: [MarsRoverImageMetadata]].self, from: data)
                    DispatchQueue.main.async {
                        completion(parsedData["photos"], nil)
                    }
                } catch (let e) {
                    DispatchQueue.main.async {
                        completion(nil, e)
                    }
                }
            }
        }
    }
    
    func downloadImage(_ metaData: MarsRoverImageMetadata, completion: @escaping (UIImage?, Error?) -> Void) {
        self.downloadFile(metaData.imgSrc, queryItems: nil) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            if let data = data {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                } else {
                    // FIXME: More error handling code
                }
            }
        }
    }
}
