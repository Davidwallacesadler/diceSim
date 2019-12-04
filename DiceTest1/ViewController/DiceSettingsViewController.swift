//
//  DiceSettingsViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 12/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class DiceSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IncrementableCellDelegate, SwitchableCellDelegate {

    
   
    
    // MARK: - Cell Delegation
    func incrementedValueDidChange(forCellKey: String, newValue: Int) {
        diceAndCounts[forCellKey] = newValue
    }

    func switchValueChanged(forCellWithId: Int, isOnStatus: Bool) {
        if forCellWithId == 0 {
            //UserDefaults.standard.set(isOnStatus, forKey: "automaticRolling")
        }
    }
    #warning("Should make models for D10, New Texture for D4, & D00")
    
    // MARK: - TableView Delegation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaderTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            return 1
            case 1:
            return diceSettingsOptionLabels.count
            case 2:
            return textureSettingsOptionLabels.count
            default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
            guard let switchableCell = tableView.dequeueReusableCell(withIdentifier: "switchableCell",for: indexPath) as? SwitchableTableViewCell else { return UITableViewCell() }
            switchableCell.mainLabel.text = "Automatic Dice Rolling"
            switchableCell.delegate = self
            switchableCell.identifier = indexPath.row
            //switchableCell.cellSwitch.isOn = UserDefaults.standard.bool(forKey: "automaticRolling")
            return switchableCell
            case 1:
            guard let incrementableCell = tableView.dequeueReusableCell(withIdentifier: "incrementableCell", for: indexPath) as? IncrementableTableViewCell else { return UITableViewCell() }
            incrementableCell.delegate = self
            incrementableCell.mainLabel.text = diceSettingsOptionLabels[indexPath.row]
            incrementableCell.key = diceSettingsOptionLabels[indexPath.row]
            incrementableCell.currentCount = diceAndCounts[diceSettingsOptionLabels[indexPath.row]] ?? 0
            return incrementableCell
            case 2:
            return UITableViewCell()
            default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Internal Properties
    #warning("pass in tuples -- (String, Int) - where the 0 coordinate is a key for the diceAndCounts dict -- plug in 1 coord. Int value as the value")
    var currentDiceAndCounts: [(String,Int)]?
    let tableHeaderTitles = ["Rolling Settings",
                             "Dice Settings",
                             "Texture Settings"]
    let diceSettingsOptionLabels = ["D4 (Tetrahedron)",
                                     "D6 (cube)",
                                     "D8 (Octahedron)",
                                     //"D10",
                                     "D12 (Dodecahedron)",
                                     "D20 (Icosahedron)"]
    let textureSettingsOptionLabels = ["Dice Textures",
                                       "Floor Textures"]
    var diceAndCounts = ["D4 (Tetrahedron)": 0, "D6 (cube)": 0, "D8 (Octahedron)": 0, "D12 (Dodecahedron)": 0, "D20 (Icosahedron)": 0]
    

    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        setupTableViewDelegation()
    }
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // call VC delegate
    }
    
    
    // MARK: - Internal Methods
    
    private func registerCustomCells() {
        tableView.register(UINib(nibName: "SwitchableTableViewCell", bundle: nil), forCellReuseIdentifier: "switchableCell")
        tableView.register(UINib(nibName: "IncrementableTableViewCell", bundle: nil), forCellReuseIdentifier: "incrementableCell")
    }
    
    private func setupTableViewDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
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
