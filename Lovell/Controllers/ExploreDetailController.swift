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
        
        let maxImageWidth = screenWidth / 1.6
        let newImageHeight = ((480 * imageHeight) / imageWidth)
        
        self.imageViewWidthConstraint.constant = CGFloat(maxImageWidth)
        self.imageViewHeightConstraint.constant = newImageHeight
    }
}
