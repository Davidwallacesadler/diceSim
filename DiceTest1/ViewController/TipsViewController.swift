//
//  TipsViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 12/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    let tips = ["Press and hold the roll button to shake the dice and let go when you want to finish the roll. Shake your phone or enable automatic rolling to move the dice around.",
                "Use the camera panning buttons to move the camera either right or left.",
                "To change the amount or type of dice you are using tap the dice settings button."
    ]
    let tipIcons = [UIImage(named:"rollDiceTipIcon")!,
                    UIImage(named:"panCameraTipIcon")!,
                    UIImage(named:"diceSettingsTipIcon")!
    ]
    var currentTipIndex = 0

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipNumberLabel.text = "Tip 1 of \(tips.count)"
        tipTextLabel.text = tips[currentTipIndex]
        tipIconImageView.image = tipIcons[currentTipIndex]
        ViewHelper.roundCornersOf(viewLayer: gotItButton.layer, withRoundingCoefficient: 5.0)
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tipNumberLabel: UILabel!
    @IBOutlet weak var tipIconImageView: UIImageView!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func backgroundPressed(_ sender: Any) {
        updateDisplayedTip()
    }
    @IBAction func gotItButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Methods
    
    private func updateDisplayedTip() {
        let tipCount = tips.count
        if currentTipIndex < tipCount - 1 {
            currentTipIndex += 1
            tipNumberLabel.text = "Tip \(currentTipIndex + 1) of \(tipCount)"
            tipTextLabel.text = tips[currentTipIndex]
            tipIconImageView.image = tipIcons[currentTipIndex]
        } else {
            currentTipIndex = 0
            tipNumberLabel.text = "Tip 1 of \(tipCount)"
            tipTextLabel.text = tips[currentTipIndex]
            tipIconImageView.image = tipIcons[currentTipIndex]
            
        }
        
    }
    
}
