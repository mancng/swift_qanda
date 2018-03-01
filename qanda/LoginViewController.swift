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
        
        let url = URL(string: "http://localhost:8000/api/users")!
        
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
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let showAllViewController = nav.topViewController as! ShowAllViewController
        showAllViewController.delegate = self
    }


}
