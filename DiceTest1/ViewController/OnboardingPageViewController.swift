//
//  OnboardingPageViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 1/22/20.
//  Copyright © 2020 David Sadler. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // ROUND BUTTON CORNERS
        ViewHelper.roundCornersOf(viewLayer: getStartedButton.layer, withRoundingCoefficient: 10.0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var getStartedButton: UIButton!
    // MARK: - Actions
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Keys.onboarding)
        self.dismiss(animated: true, completion: nil)
    }
    
}
