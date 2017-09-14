//
//  HomeController.swift
//  Lovell
//
//  Created by TJ Barber on 9/13/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let goldenRatio = 1.618
    var exploreContainingViewHeightConstraint: NSLayoutConstraint?
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
        self.hideUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.displayUIElements()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.adjustExploreHeightAccordingToGoldenRatio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.adjustExploreHeightAccordingToGoldenRatio()
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
        self.updateBackgroundsFromMotion()
        
        UIView.animate(withDuration: 0.8, delay: 1.5, options: .curveEaseIn, animations: {
            self.exploreImage.alpha = 0.5
            for imageView in [self.marsImage, self.earthImage] {
                imageView?.alpha = 0.4
            }
        }, completion: nil)
        
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
    
    func adjustExploreHeightAccordingToGoldenRatio() {
        let screenHeight = Double(UIScreen.main.bounds.size.height)
        let exploreContainingViewGoldenRatioSize = CGFloat(screenHeight / goldenRatio)
        
        if let heightConstraint = self.exploreContainingViewHeightConstraint {
            NSLayoutConstraint.deactivate([heightConstraint])
        }
        
        let heightConstraint = NSLayoutConstraint.init(item: exploreContainingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: exploreContainingViewGoldenRatioSize)
        self.exploreContainingViewHeightConstraint = heightConstraint
        NSLayoutConstraint.activate([heightConstraint])
    }
}

