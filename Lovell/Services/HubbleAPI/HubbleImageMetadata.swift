//
//  HubbleImageData.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

struct HubbleImageMetadata: Decodable {
    let id: Int
    let name: String?
    let newsName: String?
    let collection: String?
    let mission: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case newsName = "news_name"
        case collection
        case mission
    }
}
