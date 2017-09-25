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
    let placeholderColor = UIColor(white: 1.0, alpha: 0.3)
    var imageToDisplay: EarthImage?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.locationTextField.resignFirstResponder()
    }
    
    @IBAction func getCoordinatesAndDisplayImage(_ sender: Any) {
        guard let address = self.locationTextField.text else {
            AlertHelper.showAlert(withTitle: "Oops...", withMessage: "We need you to give us an address.", presentingViewController: self)
            return
        }
        
        self.getCoordinatesFrom(address) { [unowned self] coordinates, error in
            if let error = error {
                self.locationTextField.text = ""
                AlertHelper.showAlert(withTitle: "Oops...", withMessage: error.localizedDescription, presentingViewController: self)
            }
            
            guard let coordinates = coordinates else {
                self.locationTextField.text = ""
                AlertHelper.showAlert(withTitle: "Oops...", withMessage: "We had a hard time finding this location. Please try another.", presentingViewController: self)
                return
            }
            
            self.getAssetListFor(coordinates) { assetList in
                if let latestAsset = assetList.last {
                    self.getImageFor(latestAsset, coordinates: coordinates) { earthImage in
                        self.imageToDisplay = earthImage
                        //self.performSegue(withIdentifier: , sender: )
                    }
                }
            }
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
    
    func getAssetListFor(_ coordinates: CLLocationCoordinate2D, completion: @escaping ([EarthAsset]) -> Void) {
        EarthImageryAPI.sharedInstance.getAssetList(lat: coordinates.latitude, long: coordinates.longitude) { assets, error in
            if let error = error {
                AlertHelper.showAlert(withTitle: "Something went wrong...", withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            guard let assets = assets else {
                AlertHelper.showAlert(withTitle: "Something went wrong...", withMessage: "The server is current experiencing an issue. Please try again later.", presentingViewController: self)
                return
            }
            
            completion(assets)
        }
    }
    
    func getImageFor(_ asset: EarthAsset, coordinates: CLLocationCoordinate2D, completion: @escaping (EarthImage) -> Void) {
        EarthImageryAPI.sharedInstance.getEarthImage(lat: coordinates.latitude, long: coordinates.longitude, asset: asset) { earthImage, error in
            
            if let error = error {
                
                AlertHelper.showAlert(withTitle: "Something went wrong...", withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            guard let earthImage = earthImage else {
                AlertHelper.showAlert(withTitle: "Something went wrong...", withMessage: "The server is current experiencing an issue. Please try again later.", presentingViewController: self)
                return
            }
            
            completion(earthImage)
        }
    }
    
    func locationNotFoundAlert() {
        self.locationTextField.text = ""
        AlertHelper.showAlert(withTitle: "Oops...", withMessage: "We couldn't find this location. Please try another!", presentingViewController: self)
    }
}
