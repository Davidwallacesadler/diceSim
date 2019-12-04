//
//  SwitchableTableViewCell.swift
//  DiceTest1
//
//  Created by David Sadler on 12/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol SwitchableCellDelegate {
    func switchValueChanged(forCellWithId: Int, isOnStatus: Bool)
}

class SwitchableTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    var identifier: Int?
    var delegate: SwitchableCellDelegate?
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    
    // MARK: - Actions
    
    @IBAction func switchPressed(_ sender: Any) {
        cellSwitch.isOn = !cellSwitch.isOn
        guard let cellDelegate = delegate, let cellId = identifier else { return }
        cellDelegate.switchValueChanged(forCellWithId: cellId, isOnStatus: cellSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
