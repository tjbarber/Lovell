//
//  ExploreCell.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure() {
        // Clean up time
        self.imageView.image = nil
        
        // Time to configure the cell
        self.imageView.image = #imageLiteral(resourceName: "exploredefault")
    }
}
