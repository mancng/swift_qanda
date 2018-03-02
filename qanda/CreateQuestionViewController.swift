//
//  CreateQuestionViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol CreateQuestionViewControllerDelegate: class {
    func createQuestion(by controller: UIViewController, theQuestionContent: String!, theQuestionDesc: String?)
    
    func cancel(by controller: UIViewController)
    
    func logout(by controller: UIViewController)
}

class CreateQuestionViewController: UIViewController {
    
    var questionContent: String = ""
    var questionDesc: String = ""
    weak var delegate: CreateQuestionViewControllerDelegate?
    
    @IBOutlet var contentTextField: UITextView!
    @IBOutlet var descTextField: UITextView!
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let getContent = contentTextField.text!
        let getDesc = descTextField.text!
        
        delegate?.createQuestion(by: self, theQuestionContent: getContent, theQuestionDesc: getDesc)
        print("to save")
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.cancel(by:self)
        print("to cancel")
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.logout(by:self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
