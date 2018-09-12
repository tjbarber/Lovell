//
//  ImageCache.swift
//  Lovell
//
//  Created by TJ Barber on 9/11/18.
//  Copyright © 2018 Novel. All rights reserved.
//

import UIKit

class ImageCache {
    static let sharedInstance = ImageCache()
    var cache = [String: UIImage]()
}
