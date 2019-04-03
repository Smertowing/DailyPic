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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
