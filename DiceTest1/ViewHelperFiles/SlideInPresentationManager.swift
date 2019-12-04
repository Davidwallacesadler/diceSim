//
//  SlideInPresentationManager.swift
//  DiceTest1
//
//  Created by David Sadler on 11/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .bottom
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
      let presentationController = SlideInPresentationController(
        presentedViewController: presented,
        presenting: presenting,
        direction: direction
      )
      return presentationController
    }
}

