//
//  SelectableCollectionViewCell.swift
//  DiceTest1
//
//  Created by David Sadler on 12/9/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SelectableCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellBorder()
    }
    
    func setupCellBorder() {
        if self.isSelected {
            ViewHelper.applyRoundedCornerWithBorder(viewLayer: self.layer, withRoundingCoefficient: 3.0)
        } else {
            ViewHelper.roundCornersOf(viewLayer: self.layer, withRoundingCoefficient: 3.0)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
}
