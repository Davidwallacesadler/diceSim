//
//  CollectionViewTableViewCell.swift
//  DiceTest1
//
//  Created by David Sadler on 12/4/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}
