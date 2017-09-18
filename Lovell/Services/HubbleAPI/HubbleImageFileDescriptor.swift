//
//  HubbleImageFileDescriptor.swift
//  Lovell
//
//  Created by TJ Barber on 9/18/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

struct HubbleImageFileDescriptor: Codable {
    let fileUrl: String
    let fileSize: Double
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case fileUrl = "file_url"
        case fileSize = "file_size"
        case width
        case height
    }
}
