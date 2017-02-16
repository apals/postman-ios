//
//  LoginViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLoginButtonClick(_ sender: Any) {
        spinner.startAnimating()
        postmanApi.login(email: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: success)
    }
    
    func success(success: Bool) -> Void {
        OperationQueue.main.addOperation {
            self.spinner.stopAnimating()
            
            if success {
                self.performSegue(withIdentifier: "Launch", sender:self)
            } else {
                print("noooo")
                self.errorLabel.text = "Login failed. Please check your username and password"
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
