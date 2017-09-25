//
//  EarthAsset.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

struct EarthAssetList: Codable {
    let count: Int
    let results: [EarthAsset]
}

struct EarthAsset: Codable {
    let date: String
    let id: String
}
