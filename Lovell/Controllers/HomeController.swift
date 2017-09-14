//
//  ViewController.swift
//  Lovell
//
//  Created by TJ Barber on 9/13/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var motionTimer: Timer?
    
    @IBOutlet weak var logoStackView: UIStackView!
    @IBOutlet weak var exploreContainingView: UIView!
    @IBOutlet weak var exploreImage: UIImageView!
    @IBOutlet weak var exploreLabel: UILabel!
    @IBOutlet weak var marsContainingView: UIView!
    @IBOutlet weak var marsImage: UIImageView!
    @IBOutlet weak var marsLabel: UILabel!
    @IBOutlet weak var earthContainingView: UIView!
    @IBOutlet weak var earthImage: UIImageView!
    @IBOutlet weak var homeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayUIElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

// MARK: - UI Helper Methods
extension HomeController {
    func hideUIElements() {
        let views: [UIView] = [logoStackView, exploreImage, exploreLabel, marsImage, marsLabel, earthImage, homeLabel]
        for view in views {
            view.alpha = 0.0
        }
    }
    
    func displayUIElements() {
        UIView.animate(withDuration: 0.8, delay: 1.5, options: .curveEaseIn, animations: {
            self.exploreImage.alpha = 0.5
            for imageView in [self.marsImage, self.earthImage] {
                imageView?.alpha = 0.4
            }
        }, completion: { finished in
            self.updateBackgroundsFromMotion()
        })
        
        UIView.animate(withDuration: 0.8, delay: 2.5, options: .curveEaseIn, animations: {
            for label in [self.exploreLabel, self.marsLabel, self.homeLabel] {
                label?.alpha = 1.0
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 4.0, options: .curveEaseIn, animations: {
            self.logoStackView.alpha = 1.0
        }, completion: nil)
    }
    
    func updateBackgroundsFromMotion() {
        let motion = MotionService.sharedInstance
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60
            motion.showsDeviceMovementDisplay = false
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            self.motionTimer = Timer(fire: Date(), interval: (1.0/60), repeats: true, block: { timer in
                if let data = motion.deviceMotion {
                    let pitch = data.attitude.pitch
                    let roll = data.attitude.roll
                    
                    self.exploreContainingView.bounds = CGRect(x: CGFloat(roll * 10), y: CGFloat(pitch * 10), width: self.exploreContainingView.bounds.width, height: self.exploreContainingView.bounds.height)
                    
                    self.marsContainingView.bounds = CGRect(x: CGFloat(roll * 10), y: CGFloat(pitch * 10), width: self.marsContainingView.bounds.width, height: self.marsContainingView.bounds.height)
                    
                    self.earthContainingView.bounds = CGRect(x: CGFloat(roll * 10), y: CGFloat(pitch * 10), width: self.earthContainingView.bounds.width, height: self.earthContainingView.bounds.height)
                }
            })
            
            if let timer = self.motionTimer {
                RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
            }
        }
    }
}

