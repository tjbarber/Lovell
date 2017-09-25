//
//  EarthDetailController.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import CoreLocation

class EarthDetailController: UIViewController {
    static let segueIdentifier = "earthDetailSegue"
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndDisplayImage()
    }
    
    func loadAndDisplayImage() {
        guard let location = location else {
            return
        }
        
        self.getAssetListFor(location) { assetList in
            guard let latestAsset = assetList.last else {
                return
            }
            
            self.getImageFor(latestAsset, coordinates: location) { imageMetadata in
                self.downloadImage(imageMetadata) { image, error in
                    if let error = error {
                        AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self)
                        return
                    }
                    
                    if let image = image {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}

// MARK: Helper Methods
extension EarthDetailController {
    func getAssetListFor(_ coordinates: CLLocationCoordinate2D, completion: @escaping ([EarthAsset]) -> Void) {
        EarthImageryAPI.sharedInstance.getAssetList(lat: coordinates.latitude, long: coordinates.longitude) { assets, error in
            if let error = error {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            guard let assets = assets else {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.internalServerError.rawValue, presentingViewController: self)
                return
            }
            
            completion(assets)
        }
    }
    
    func getImageFor(_ asset: EarthAsset, coordinates: CLLocationCoordinate2D, completion: @escaping (EarthImage) -> Void) {
        EarthImageryAPI.sharedInstance.getEarthImage(lat: coordinates.latitude, long: coordinates.longitude, asset: asset) { earthImage, error in
            if let error = error {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self)
                return
            }
            
            guard let earthImage = earthImage else {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.internalServerError.rawValue, presentingViewController: self)
                return
            }
            
            completion(earthImage)
        }
    }
    
    func downloadImage(_ metadata: EarthImage, completion: @escaping (UIImage?, Error?) -> Void) {
        EarthImageryAPI.sharedInstance.downloadFile(metadata.url, queryItems: nil) { data, error in
            if let _ = error {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: ErrorMessages.internalServerError.rawValue, presentingViewController: self) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            if let data = data {
                let image = UIImage(data: data)
                if let image = image {
                    completion(image, nil)
                }
            }
        }
    }
}
