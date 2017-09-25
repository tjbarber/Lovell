//
//  ExploreDetailController.swift
//  Lovell
//
//  Created by TJ Barber on 9/19/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ExploreDetailController: UIViewController {
    static let segueIdentifier = "exploreDetailSegue"
    
    let imageWidthDivisor: CGFloat = 1.6
    var selectedImage: HubbleImage?
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineImageSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.selectedImage?.thumbnail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func determineImageSize() {
        guard let imageHeight = self.selectedImage?.thumbnail?.size.height,
            let imageWidth = self.selectedImage?.thumbnail?.size.width else { return }
        
        let screenWidth  = UIScreen.main.bounds.size.width
        
        // This is where we calculate the max width of the image view
        // We have to make sure though that the height is set properly to fit
        // the original image's aspect ratio.
        let maxImageWidth = screenWidth / imageWidthDivisor
        let newImageHeight = ((maxImageWidth * imageHeight) / imageWidth)
        
        self.imageViewWidthConstraint.constant = CGFloat(maxImageWidth)
        self.imageViewHeightConstraint.constant = newImageHeight
    }
}
