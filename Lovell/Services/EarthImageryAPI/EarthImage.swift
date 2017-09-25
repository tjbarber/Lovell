//
//  EarthImage.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

struct EarthImage: Codable {
    let date: String
    let url: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case url
        case id
    }
}
