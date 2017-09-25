//
//  EarthController.swift
//  Lovell
//
//  Created by TJ Barber on 9/14/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import CoreLocation

class EarthController: DetailViewController {
    static let segueIdentifier = "earthSegue"
    let earthDetailPresentAnimationController = ModalImagePresentationTransitionController()
    let earthDetailDismissAnimationController = ModalImageDismissTransitionController()
    
    let placeholderColor = UIColor(white: 1.0, alpha: 0.3)
    var locationToDisplay: CLLocationCoordinate2D?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.locationTextField.resignFirstResponder()
    }
    
    @IBAction func getCoordinatesAndDisplayImage(_ sender: Any) {
        self.dismissKeyboard(self)
        
        guard let address = self.locationTextField.text else {
            AlertHelper.showAlert(withTitle: ErrorMessages.oops.rawValue, withMessage: ErrorMessages.addressNeeded.rawValue, presentingViewController: self)
            return
        }
        
        self.getCoordinatesFrom(address) { [unowned self] coordinates, error in
            if let error = error {
                self.locationTextField.text = ""
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self)
            }
            
            guard let coordinates = coordinates else {
                self.locationTextField.text = ""
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.locationNotFound.rawValue, presentingViewController: self)
                return
            }
            
            self.locationToDisplay = coordinates
            self.performSegue(withIdentifier: "earthDetailSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Where do you want to visit?", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "earthDetailSegue":
                let destination = segue.destination as! EarthDetailController
                destination.location = self.locationToDisplay
                destination.modalPresentationStyle = .overFullScreen
                destination.transitioningDelegate = self
            default: return
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: Helper Methods
extension EarthController {
    func getCoordinatesFrom(_ address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [unowned self] placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let placemarks = placemarks else {
                DispatchQueue.main.async {
                    self.locationNotFoundAlert()
                }
                return
            }
            
            guard let placemark = placemarks.first,
                let location = placemark.location else {
                DispatchQueue.main.async {
                    self.locationNotFoundAlert()
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(location.coordinate, nil)
            }
        }
    }
    
    func locationNotFoundAlert() {
        self.locationTextField.text = ""
        AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.locationNotFound.rawValue, presentingViewController: self)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension EarthController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        earthDetailPresentAnimationController.originFrame = CGRect.zero
        return earthDetailPresentAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.locationToDisplay = nil
        earthDetailDismissAnimationController.originFrame = CGRect.zero
        return earthDetailDismissAnimationController
    }
}
