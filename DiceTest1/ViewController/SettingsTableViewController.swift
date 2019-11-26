//
//  SettingsTableViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 4/16/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView DataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    // MARK: - View Lifecycle
    
    // TODO: - make it so there is something that is keeping track of how many dice are in the world -- only allow 3 for now. Need logic for handling this.
    
    // TODO: - Maybe think of setting all the dice in one picker that has component sections that can select the number for each corrosponding dice type.
    override func viewDidLoad() {
        super.viewDidLoad()
        diceCountPicker.delegate = self
        diceCountPicker.dataSource = self
        
        pickerData = ["1", "2", "3"]
    }
    
    // MARK: - Properties
    var pickerData: [String] = []
    
    // MARK: - Outlets
    
    @IBOutlet var diceCountPicker: UIPickerView!
    @IBOutlet weak var regularDiceCountTextField: UITextField!
    @IBOutlet weak var tetrahedronDiceCountTextField: UITextField!
    @IBOutlet weak var octahedronDiceCountTextField: UITextField!
    @IBOutlet weak var icosahedronDiceCountTextField: UITextField!
    @IBOutlet weak var dodecahedronDiceCountTextField: UITextField!
    
    // MARK: - Actions
    
    
    
}
