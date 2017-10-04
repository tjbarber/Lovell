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
    
    let placeholderColor = UIColor.init(white: 0.8, alpha: 1.0)
    var marsImage: UIImage?
    
    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var recipientStackView: UIStackView!
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
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
            // This is used so that the popover controller's arrow is at the center of the button.
            popoverPresentationController.sourceRect = CGRect(x: (self.sendButton.bounds.width / 2.0), y: 0.0, width: 0.0, height: 0.0)
        }
        self.present(activityController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextView.text = "Message:"
        self.messageTextView.textColor = placeholderColor
        self.messageTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateImageView()
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

        // Redisplay elements after screenshot is taken.
        // This happens so fast you don't see them flicker.
        self.closeButtonImageView.isHidden = false
        self.sendButton.isHidden = false
        
        return image
    }
}
