//
//  DiceSelectionViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 11/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class DiceSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Pickerview Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == diceTypePickerView {
            return diceTypeNames.count
        } else {
            return diceCounts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == diceTypePickerView {
            return diceTypeNames[row].1
        } else {
            return "\(diceCounts[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == diceTypePickerView {
            selectedDiceType = diceTypeNames[row].0
        } else {
            selectedDiceCount = diceCounts[row]
        }
    }
    
    // MARK: - Internal Properties

    //var sceneKitDiceDelegate: SceneKitDiceDelegate?
    
    let diceTypeNames = [
        (Keys.customTetrahedron, "D4"),
        (Keys.customCube, "D6"),
        (Keys.customOctahedron, "D8"),
        (Keys.customD10, "D10"),
        (Keys.customDodecahedron, "D12"),
        (Keys.customIcosahedron, "D20")
    ]
    let diceCounts = [
        1, 2, 3, 4, 5
    ]
    var selectedDiceType = Keys.customTetrahedron
    var selectedDiceCount: Int = 1
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diceTypePickerView.delegate = self
        diceTypePickerView.dataSource = self
        diceCountPickerView.delegate = self
        diceCountPickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var diceTypePickerView: UIPickerView!
    @IBOutlet weak var diceCountPickerView: UIPickerView!
    // MARK: - Actions
    
    @IBAction func applyButtonPressed(_ sender: Any) {
//        guard let delegate = sceneKitDiceDelegate else { return }
//        delegate.updateDiceSelection(diceKind: selectedDiceType, diceCount: selectedDiceCount)
//        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
