//
//  IncrementableTableViewCell.swift
//  DiceTest1
//
//  Created by David Sadler on 12/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol IncrementableCellDelegate {
    func incrementedValueDidChange(forCellKey: String, newValue: Int)
}

class IncrementableTableViewCell: UITableViewCell {
    // MARK: - Internal Properties
    
    var delegate: IncrementableCellDelegate?
    var identifer: Int?
    var key: String?
    var currentCount = 0
    var incrementingIsDisabled: Bool = false
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var upArrowButton: UIButton!
    @IBOutlet weak var downArrowButton: UIButton!
    @IBOutlet weak var diceIconImageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func downButtonPressed(_ sender: Any) {
        guard let cellDelegate = delegate, let cellKey = key else { return }
        if currentCount > 0 {
            currentCount -= 1
            updateCountLabel()
            cellDelegate.incrementedValueDidChange(forCellKey: cellKey, newValue: currentCount)
        }
    }
    @IBAction func upButtonPressed(_ sender: Any) {
        guard let cellDelegate = delegate, let cellKey = key else { return }
        if !incrementingIsDisabled {
            currentCount += 1
            updateCountLabel()
            cellDelegate.incrementedValueDidChange(forCellKey: cellKey, newValue: currentCount)
        }
    }
    
    // MARK: - Internal Methods
    
    func updateCountLabel() {
        countLabel.text = "\(currentCount)"
    }
    
    private func updateDelegate() {
        guard let cellDelegate = delegate, let cellId = identifer else { return }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
