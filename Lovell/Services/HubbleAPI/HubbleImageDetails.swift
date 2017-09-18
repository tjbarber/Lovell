//
//  HubbleImageDetails.swift
//  Lovell
//
//  Created by TJ Barber on 9/18/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

struct HubbleImageDetails: Codable {
    let name: String?
    let description: String?
    let credits: String?
    let imageFiles: [HubbleImageFileDescriptor]
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case credits
        case imageFiles = "image_files"
    }
}
