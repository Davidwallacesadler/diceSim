//
//  ViewHelper.swift
//  DiceTest1
//
//  Created by David Sadler on 12/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//
import Foundation
import UIKit

struct ViewHelper {
    static func roundCornersOf(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 1.0
        viewLayer.borderColor = UIColor.clear.cgColor
        viewLayer.masksToBounds = true
    }
    static func applyRoundedCornerWithBorder(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 2.0
        viewLayer.borderColor = UIColor.gray.cgColor
        viewLayer.masksToBounds = true
    }
}
