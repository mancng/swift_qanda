//
//  LoginViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/27/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, ShowAllViewControllerDelegate {
    
    var userName: String = ""

    @IBOutlet var nameTxtField: UITextField!
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        userName = nameTxtField.text!

        let parameters = ["name": userName]
        
        let url = URL(string: "\(apiUrl.http)api/users")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask (with: request as URLRequest, completionHandler: {
            data, response, error in
            
            guard error == nil else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    if let dictionary = json as? [String: Any] {
                        if let name = dictionary["name"] as? String {
                            if name == "ValidationError" {
                                print("Parsed an error message")
                            } else {
                                // Switch back to the main thread
                                OperationQueue.main.addOperation {
                                    self.performSegue(withIdentifier: "showAllSegue", sender: self)
                                }
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllSegue" {
            let nav = segue.destination as! UINavigationController
            let showAllViewController = nav.topViewController as! ShowAllViewController
            showAllViewController.delegate = self
        } else {
            print("NOT logged in")
        }
    }
    
    @objc func hideKeyBoard(sender: UITapGestureRecognizer? = nil){
        view.endEditing(true)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
