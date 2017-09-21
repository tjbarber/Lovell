//
//  ExploreDetailController.swift
//  Lovell
//
//  Created by TJ Barber on 9/19/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ExploreDetailPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class ExploreDetailDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        containerView.addSubview(fromVC.view)
        fromVC.view.alpha = 1.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromVC.view.alpha = 0.0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

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
