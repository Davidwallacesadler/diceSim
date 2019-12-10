//
//  DiceSettingsViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 12/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class DiceSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IncrementableCellDelegate, SwitchableCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
            case 0:
            return diceTextureImagesAndNames.count
            case 1:
            return floorTextureImagesAndNames.count
            case 2:
            return wallTextureImagesAndNames.count
            default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectableCell", for: indexPath) as? SelectableCollectionViewCell else { return UICollectionViewCell() }
        switch collectionView.tag {
            case 0:
            cell.label.text = diceTextureImagesAndNames[indexPath.row].0
            cell.imageView.image = diceTextureImagesAndNames[indexPath.row].1
            case 1:
            cell.label.text = floorTextureImagesAndNames[indexPath.row].0
            cell.imageView.image = floorTextureImagesAndNames[indexPath.row].1
            case 2:
            cell.label.text = wallTextureImagesAndNames[indexPath.row].0
            cell.imageView.image = wallTextureImagesAndNames[indexPath.row].1
            default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
            case 0:
                guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SelectableCollectionViewCell else { return }
                selectedCell.isSelected = true
                selectedCell.setupCellBorder()
                selectedDiceTexture = indexPath.row
                print("selected dice int is \(indexPath.row)")
            case 1:
                guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SelectableCollectionViewCell else { return }
                selectedCell.isSelected = true
                selectedCell.setupCellBorder()
                selectedFloorTexture = indexPath.row
                print("selected floor int is \(indexPath.row)")
            case 2:
                guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SelectableCollectionViewCell else { return }
                selectedCell.isSelected = true
                selectedCell.setupCellBorder()
                selectedWallTexture = indexPath.row
                print("selected wall int is \(indexPath.row)")
            default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SelectableCollectionViewCell else { return }
        selectedCell.isSelected = false
        selectedCell.setupCellBorder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
   
    
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
    #warning("New Texture for D4")
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 175.0
        } else {
            return 50.0
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
            guard let collectionViewTableCell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
            collectionViewTableCell.mainLabel.text = textureSettingsOptionLabels[indexPath.row]
            collectionViewTableCell.collectionView.tag = indexPath.row
            collectionViewTableCell.collectionView.dataSource = self
            collectionViewTableCell.collectionView.delegate = self
            return collectionViewTableCell
            default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Internal Properties
    var delegate: DiceSettingsDelegate?
    let diceTextureImagesAndNames: [(String,UIImage)] = [
        ("Red and White", UIImage(named:"redDiceCellImage")!),
        ("Ivory and Black", UIImage(named:"whiteDiceCellImage")!),
        ("Black and Lavender", UIImage(named:"blackDiceCellImage")!)
    ]
    let floorTextureImagesAndNames: [(String,UIImage)] = [
        ("Black Marble", UIImage(named:"blackMarbleCellImage")!),
        ("White Marble", UIImage(named:"whiteMarbleCellImage")!),
        ("Wood", UIImage(named:"woodCellImage")!)
    ]
    let wallTextureImagesAndNames: [(String,UIImage)] = [
        ("Twilight", UIImage(named:"twilightBackground")!),
        ("SeaFoam", UIImage(named:"seafoamBackground")!),
        ("Sky Blue", UIImage(named:"skyBlueBackground")!)
    ]
    var selectedDiceTexture: Int?
    var selectedFloorTexture: Int?
    var selectedWallTexture: Int?
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
                                       "Floor Textures",
                                       "Wall Textures"]
    var diceAndCounts = ["D4": 0,
                         "D6": 0,
                         "D8": 0,
                         "D10": 0,
                         "D00": 0,
                         "D12": 0,
                         "D20": 0]
    var currentDiceCount = 0
    var selectedDiceType = Keys.customTetrahedron
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
        if let diceTexture = selectedDiceTexture {
            UserDefaults.standard.set(diceTexture, forKey: Keys.selectedDiceTexturePack)
        }
        if let floorTexture = selectedFloorTexture {
            UserDefaults.standard.set(floorTexture, forKey: Keys.selectedFloorTexture)
            sceneKitSpawningDelegate.updateRoomFloor(shouldUpdate: true)
        }
        if let wallTexture = selectedWallTexture {
            UserDefaults.standard.set(wallTexture, forKey: Keys.selectedWallTexturePack)
            sceneKitSpawningDelegate.updateRoomWalls(shouldUpdate: true)
        }
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
        tableView.register(UINib(nibName: "CollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionCell")
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
                    diceFilePath = Keys.customD00
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
