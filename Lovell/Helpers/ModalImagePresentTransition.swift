//
//  ModalImageTransition.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ModalImagePresentationTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
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
