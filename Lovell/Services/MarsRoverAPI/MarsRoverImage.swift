//
//  MarsRoverImage.swift
//  Lovell
//
//  Created by TJ Barber on 9/20/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

struct MarsRoverCameraMetadata: Codable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}

struct MarsRoverBasicCameraMetadata: Codable {
    let fullName: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}

struct MarsRoverMetadata: Codable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let cameras: [MarsRoverBasicCameraMetadata]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}

struct MarsRoverImageMetadata: Decodable {
    let id: Int
    let sol: Int
    let camera: MarsRoverCameraMetadata
    let imgSrc: String
    let earthDate: String
    let rover: MarsRoverMetadata
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}
