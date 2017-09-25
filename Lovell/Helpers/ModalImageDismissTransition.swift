//
//  ModalImageDismissTransition.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ModalImageDismissTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
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

