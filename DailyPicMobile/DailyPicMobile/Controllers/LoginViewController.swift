//
//  LoginViewController.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 4/3/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var bottomWithKeyboardValue: CGFloat = 40
    var bottomWithoutKeyboardValue: CGFloat = 112
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBOutlet weak var buttonOffset: NSLayoutConstraint!
    
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

extension LoginViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        buttonOffset.constant = bottomWithKeyboardValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        buttonOffset.constant = bottomWithoutKeyboardValue
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
