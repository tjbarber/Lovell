//
//  HubbleImage.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

enum HubbleImageState {
    case new, downloaded, failed
}

class HubbleImage {
    let metadata: HubbleImageMetadata
    var details: HubbleImageDetails?
    var thumbnail: UIImage?
    var fullImage: UIImage?
    var thumbnailImageState: HubbleImageState = .new
    var fullImageState: HubbleImageState = .new
    
    init(withMetadata metadata: HubbleImageMetadata) {
        self.metadata = metadata
    }
}
