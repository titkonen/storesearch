//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Toni Itkonen on 14/06/2019.
//  Copyright © 2019 Toni Itkonen. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
        
        // Animate background gradient view
        dimmingView.alpha = 0
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }
    }
}
