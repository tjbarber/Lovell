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
            self.activityIndicator.stopAnimating()
            animateImageView()
        }
    }
    
    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var recipientStackView: UIStackView!
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func stopEditing(_ sender: UITapGestureRecognizer) {
        self.recipientName.resignFirstResponder()
        self.messageTextView.resignFirstResponder()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let recipientName = self.recipientName.text {
            if recipientName.isEmpty {
                AlertHelper.showAlert(withTitle: ErrorMessages.oops.rawValue, withMessage: ErrorMessages.mustProvideRecipientName.rawValue, presentingViewController: self)
                return
            }
        }
        
        if let message = self.messageTextView.text {
            if message.isEmpty {
                AlertHelper.showAlert(withTitle: ErrorMessages.oops.rawValue, withMessage: ErrorMessages.mustHaveMessage.rawValue, presentingViewController: self)
            }
        }
        
        let screenshot = takeScreenshot()
        guard let unwrappedScreenshot = screenshot else {
            AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.unableToSendMessage.rawValue, presentingViewController: self)
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [unwrappedScreenshot], applicationActivities: nil)
        if let popoverPresentationController = activityController.popoverPresentationController {
            popoverPresentationController.sourceView = self.sendButton
            popoverPresentationController.sourceRect = CGRect(x: (self.sendButton.bounds.width / 2.0), y: 0.0, width: 0.0, height: 0.0)
        }
        self.present(activityController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.text = "Message:"
        messageTextView.textColor = placeholderColor
        messageTextView.delegate = self
        
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            guard let images = images else {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.pleaseTryAgainLater.rawValue, presentingViewController: self) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            if let firstImage = images.first {
                MarsRoverAPI.sharedInstance.downloadImage(firstImage) { image, error in
                    if let error = error {
                        print(error.localizedDescription)
                        AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.internalServerError.rawValue, presentingViewController: self) { [unowned self] action in
                            self.dismiss(animated: true, completion: nil)
                        }
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
            for view in [self.recipientStackView, self.seperatorView, self.messageTextView, self.sendButton] {
                view?.alpha = 1.0
            }
        }, completion: nil)
    }
    
    func takeScreenshot() -> UIImage? {
        // Hide unneeded elements
        self.closeButtonImageView.isHidden = true
        self.sendButton.isHidden = true
        
        let screenshotHeight = (UIScreen.main.bounds.size.height)
        let screenshotWidth = UIScreen.main.bounds.size.width
        let screenshotSize = CGSize(width: screenshotWidth, height: screenshotHeight)
        let screenshotBounds = CGRect(x: 0, y: 0, width: screenshotWidth, height: screenshotHeight)
        
        UIGraphicsBeginImageContextWithOptions(screenshotSize, false, UIScreen.main.scale)
        self.view.drawHierarchy(in: screenshotBounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.closeButtonImageView.isHidden = false
        self.sendButton.isHidden = false
        
        return image
    }
}
