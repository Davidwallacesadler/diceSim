//
//  AppSettingsViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 12/13/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Delegation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appSettingsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disclosureCell", for: indexPath)
        cell.textLabel?.text = appSettingsTitles[indexPath.row]
        cell.imageView?.image = appSettingsImages[indexPath.row]
        switch self.traitCollection.userInterfaceStyle {
            case .dark:
            cell.imageView?.tintColor = .white
            default:
            cell.imageView?.tintColor = .darkGray
        }
        return cell
    }
    
    
    // MARK: - Internal Properties
    
    //let appSettingsHeaderTitles = [""]
    let appSettingsTitles = ["Provide Feedback",
                             "Rate on the Store",
                             "Share",
                             "Upgrade to Pro"
    ]
    let appSettingsImages = [UIImage(named: "feedbackIcon")!,
                             UIImage(named: "rateIcon")!,
                             UIImage(named: "shareIcon")!,
                             UIImage(named: "purchaseIcon")!
    ]
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
        ViewHelper.roundCornersOf(viewLayer: handleBarView.layer, withRoundingCoefficient: 7.0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleBarView: UIView!
    
    // MARK: - Actions
    
    @IBAction func topHandleButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Methods
    
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
