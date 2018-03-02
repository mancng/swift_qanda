//
//  CreateAnswerViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol CreateAnswerViewControllerDelegate: class {
    func createAnswer(by controller: UIViewController, answerContent: String, answerDesc: String, theQuestionId: String, writer: String)
    
    func cancel(by controller: UIViewController)
    
    func logout(by controller: UIViewController)
}

class CreateAnswerViewController: UIViewController {
    
    var theQuestion: Question = Question()
    var answerContent: String = ""
    var answerDesc: String = ""
    var questionId: String = ""
    var userName: String = ""
    weak var delegate: CreateAnswerViewControllerDelegate?

    @IBOutlet var questionContentLabel: UILabel!
    @IBOutlet var questionDescLabel: UILabel!
    @IBOutlet var answerContentTextField: UITextView!
    @IBOutlet var answerDescTextField: UITextView!
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.cancel(by:self)
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.logout(by:self)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let getAnswerContent = answerContentTextField.text!
        let getAnswerDesc = answerDescTextField.text!
        
        delegate?.createAnswer(by: self, answerContent: getAnswerContent, answerDesc: getAnswerDesc, theQuestionId: questionId, writer: userName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionContentLabel.text = theQuestion.questionContent
        questionDescLabel.text = theQuestion.questionDesc

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
