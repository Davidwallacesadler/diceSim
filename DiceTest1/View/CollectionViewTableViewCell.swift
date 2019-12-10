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
        self.collectionView.register(UINib(nibName: "SelectableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectableCell")
        self.collectionView.allowsSelection = true
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
}
