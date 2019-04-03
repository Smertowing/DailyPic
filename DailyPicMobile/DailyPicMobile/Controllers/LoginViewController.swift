//
//  LoginViewController.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 4/3/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBOutlet weak var serveripTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        resignFirstResponder()
        guard let serverip = serveripTextField.text else {
            UIAlertController.showError(with: "Server ip field is empty", on: self)
            return
        }
        
        guard let nickname = nicknameTextField.text else {
            UIAlertController.showError(with: "Nickname field is empty", on: self)
            return
        }
        
        UserProfile.serverIp = serverip
        UserProfile.username = nickname

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DailyPicClient.ping() { error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let _ = error {
                    UIAlertController.showError(with: "Cannot reach server", on: self)
                } else {
                    let exclusiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "modelsTableView") as! ModelsTableViewController
                    self.show(exclusiveViewController, sender: self)
                }
            }
        }
        
        
    }



}
