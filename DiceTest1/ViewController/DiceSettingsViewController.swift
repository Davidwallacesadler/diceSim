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
        // Make sure counts are below the maximum -- if max is hit - reloadTableView Section -- gray out up arrows
        diceAndCounts[forCellKey] = newValue
        let currentTotalCount = diceAndCounts.reduce(0) { (x, y) -> Int in
              x + y.value
        }
        if currentDiceCount < 5 {
            currentDiceCount = currentTotalCount
            if currentTotalCount == 5 {
                shouldRestrictAddingDice = true
                updateIncrementableCells()
            }
            print(diceAndCounts.description)
        }
        if currentDiceCount >= 5 {
            if currentTotalCount < 5 {
                currentDiceCount = currentTotalCount
                shouldRestrictAddingDice = false
                updateIncrementableCells()
            }
        }
    }

    func switchValueChanged(forCellWithId: Int, isOnStatus: Bool) {
        if forCellWithId == 0 {
            UserDefaults.standard.set(isOnStatus, forKey: Keys.automaticDiceRolling)
            print("Automatic Rolling: \(isOnStatus)")
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
            switchableCell.cellSwitch.isOn = UserDefaults.standard.bool(forKey: Keys.automaticDiceRolling)
            return switchableCell
            case 1:
            guard let incrementableCell = tableView.dequeueReusableCell(withIdentifier: "incrementableCell", for: indexPath) as? IncrementableTableViewCell else { return UITableViewCell() }
            incrementableCell.delegate = self
            incrementableCell.mainLabel.text = diceSettingsOptionLabels[indexPath.row]
            incrementableCell.key = diceSettingsOptionLabels[indexPath.row]
            incrementableCell.currentCount = diceAndCounts[diceSettingsOptionLabels[indexPath.row]]!
            incrementableCell.updateCountLabel()
            incrementableCell.diceIconImageView.tintColor = .white
            incrementableCell.diceIconImageView.image = UIImage(named: diceIconNames[indexPath.row])
            if shouldRestrictAddingDice {
                incrementableCell.upArrowButton.tintColor = .lightGray
                incrementableCell.incrementingIsDisabled = true
            } else {
                incrementableCell.upArrowButton.tintColor = .systemBlue
                incrementableCell.incrementingIsDisabled = false
            }
            return incrementableCell
            case 2:
            return UITableViewCell()
            default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Internal Properties
    #warning("pass in tuples -- (String, Int) - where the 0 coordinate is a key for the diceAndCounts dict -- plug in 1 coord. Int value as the value")
    var delegate: DiceSettingsDelegate?
    var currentDiceAndCounts: [(String,Int)]? {
        didSet {
            updateDiceAndCountDictionary()
        }
    }
    let diceIconNames = ["d4Icon", "d6Icon","d8Icon","d10Icon","d10Icon","d12Icon","d20Icon"]
    let tableHeaderTitles = ["Rolling Settings",
                             "Dice Settings",
                             "Texture Settings"]
    let diceSettingsOptionLabels = ["D4",
                                     "D6",
                                     "D8",
                                     "D10",
                                     "D00",
                                     "D12",
                                     "D20"]
    let textureSettingsOptionLabels = ["Dice Textures",
                                       "Floor Textures"]
    var diceAndCounts = ["D4": 0,
                         "D6": 0,
                         "D8": 0,
                         "D10": 0,
                         "D00": 0,
                         "D12": 0,
                         "D20": 0]
//    let diceTypeNames = [
//        (Keys.customTetrahedron, "D4"),
//        (Keys.customCube, "D6"),
//        (Keys.customOctahedron, "D8"),
//        (Keys.customD10, "D10"),
//        (Keys.customDodecahedron, "D12"),
//        (Keys.customIcosahedron, "D20")
//    ]
//    let diceCounts = [
//        1, 2, 3, 4, 5
//    ]
    var currentDiceCount = 0
    var selectedDiceType = Keys.customTetrahedron
    var selectedDiceCount: Int = 1

    var shouldRestrictAddingDice = false
    
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
        let diceAndCountsToPass = prepareSelectedDiceData()
        guard let sceneKitSpawningDelegate = delegate else { return }
        sceneKitSpawningDelegate.updateSpawnedDice(dicePathsAndCounds: diceAndCountsToPass)
        self.dismiss(animated: true, completion: nil)
        // call VC delegate
    }
    
    // MARK: - Internal Methods
    
    private func updateDiceAndCountDictionary() {
        guard let diceAndCountParis = currentDiceAndCounts else { return }
        for pair in diceAndCountParis {
            diceAndCounts[pair.0] = pair.1
            currentDiceCount += pair.1
        }
        if currentDiceCount == 5 {
            shouldRestrictAddingDice = true
        }
    }
    
    private func registerCustomCells() {
        tableView.register(UINib(nibName: "SwitchableTableViewCell", bundle: nil), forCellReuseIdentifier: "switchableCell")
        tableView.register(UINib(nibName: "IncrementableTableViewCell", bundle: nil), forCellReuseIdentifier: "incrementableCell")
    }
    
    private func setupTableViewDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateIncrementableCells() {
        tableView.reloadSections(IndexSet([1]), with: UITableView.RowAnimation.none)
    }
    
    private func prepareSelectedDiceData() -> [(String, Int)] {
        let dicePathsAndCounts = diceAndCounts.compactMap { (diceNameAndCount) -> (String,Int)? in
            if diceNameAndCount.value == 0 {
                return nil
            } else {
                var diceFilePath = ""
                switch diceNameAndCount.key {
                    case "D4":
                    diceFilePath = Keys.customTetrahedron
                    case "D6":
                    diceFilePath = Keys.customCube
                    case "D8":
                    diceFilePath = Keys.customOctahedron
                    case "D10":
                    diceFilePath = Keys.customD10
                    case "D00":
                    diceFilePath = Keys.customD10
                    case "D12":
                    diceFilePath = Keys.customDodecahedron
                    case "D20":
                    diceFilePath = Keys.customIcosahedron
                    default:
                    print("ERROR: Defaulting in prerpareSelectedDiceData()")
                }
                return (diceFilePath, diceNameAndCount.value)
            }
        }
        return dicePathsAndCounts
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
