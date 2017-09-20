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
    let sol = 1000
    let placeholderColor = UIColor.init(white: 0.8, alpha: 1.0)
    var marsImage: UIImage? {
        didSet {
            self.marsImageView.image = self.marsImage
            animateImageView()
        }
    }
    
    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func stopEditing(_ sender: UITapGestureRecognizer) {
        self.recipientName.resignFirstResponder()
        self.messageTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        recipientName.attributedPlaceholder = NSAttributedString(string: "To:", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        messageTextView.text = "Message:"
        messageTextView.textColor = placeholderColor
        messageTextView.delegate = self
        
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Text View Delegate
extension MarsController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == self.placeholderColor {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message:"
            textView.textColor = self.placeholderColor
        }
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
                        self.marsImage = image
                    }
                }
            }
        }
    }
    
    func animateImageView() {
        UIView.animate(withDuration: 1.0) {
            self.marsImageView.alpha = 0.2
        }
        
        UIView.animate(withDuration: 0.6, delay: 1.0, options: .curveEaseIn, animations: {
            for view in [self.recipientName, self.seperatorView, self.messageTextView, self.sendButton] {
                view?.alpha = 1.0
            }
        }, completion: nil)
    }
}
