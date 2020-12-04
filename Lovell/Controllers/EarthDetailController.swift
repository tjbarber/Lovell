//
//  EarthDetailController.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class EarthDetailController: UIViewController {
    static let segueIdentifier = "earthDetailSegue"
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = self.location {
            let mapPin = MKPointAnnotation()
            mapPin.coordinate = location
            self.mapView.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapView.addAnnotation(mapPin)
        }
    }
}
