//
//  MarsController.swift
//  Lovell
//
//  Created by TJ Barber on 9/14/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class MarsController: DetailViewController {
    static let segueIdentifier = "marsSegue"
    // In this version of the app we're only going to display images from Curiosity's first day on Mars.
    // It took 8 pictures with its Front Hazard Avoidance Camera. We're going to randomly pick one of them.
    let sol = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Helper Methods
extension MarsController {
    func loadImage() {
        MarsRoverAPI.sharedInstance.getImageMetadataFrom(.curiosity, camera: .fhaz, sol: sol) { images, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            guard let images = images else { fatalError() }
            if let firstImage = images.first {
                MarsRoverAPI.sharedInstance.downloadImage(firstImage) { image, error in
                    if let error = error {
                        // FIXME: Error handling code here
                    }
                    
                    if let image = image {
                        // Set the image
                    }
                }
            }
        }
    }
}
