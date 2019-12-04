//
//  SlideInPresentationController.swift
//  DiceTest1
//
//  Created by David Sadler on 11/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
    // MARK: - Properties
    
    private var dimmingView: UIView!
    private var direction: PresentationDirection
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width * (0.5)
        case .bottom:
            frame.origin.y = containerView!.frame.height * (0.65)
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    // MARK: - Initializer
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection) {
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    // MARK: - Override Methods
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate( NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
            options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate( NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
            options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 1.0
        })
    }
  
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(0.5), height: parentSize.height)
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.65))
        }
    }
}

// MARK: - Extensions

private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
