//
//  HubbleAPI.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

class HubbleAPI: API {
    static let sharedInstance = HubbleAPI()
    override private init() {}
    
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
}
