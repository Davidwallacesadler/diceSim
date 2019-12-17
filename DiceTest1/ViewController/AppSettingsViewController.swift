//
//  AppSettingsViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 12/13/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class AppSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
            showFeedbackEmail()
            case 1:
            rateApp()
            case 2:
            shareApp()
            case 3:
            // Purchase
            print("purchase")
            default:
            return
        }
    }
    
    
    // MARK: - Internal Properties
    
    //let appSettingsHeaderTitles = [""]
    let appSettingsTitles = ["Provide Feedback",
                             "Rate on the App Store",
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

    private func showFeedbackEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["davidwallacesadler@gmail.com"])
            mail.setSubject("Dice Roll Feedback")
            present(mail, animated: true)
        } else {
            let couldNotAccessEmailAlert = UIAlertController(title: "Error Accessing Mail", message: "Could not access your mail account. Please try again once you have set up your default Apple mail app.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            couldNotAccessEmailAlert.addAction(okayAction)
            present(couldNotAccessEmailAlert, animated: true)
        }
    }
    
    #warning("Implement AppID and AppURL")
    private func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let appId = ""
            guard let url = URL(string: "itms://itunes.apple.com/app/" + appId) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func shareApp() {
        let appStoreURL = ""
        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
