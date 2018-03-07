//
//  SingleQuestionViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol SingleQuestionViewControllerDelegate: class {
    func addLike(by controller: UIViewController, quesitonId: String, answerId: String)
    
    func cancel(by controller: UIViewController)
    
    func logout(by controller: UIViewController)
}

class SingleQuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AnswerTableViewCellDelegate {

    var getSingleQuestion: Question = Question()
    var questionId: String = ""
    var questionContent: String = ""
    var questionDesc: String = ""
    var allAnswers = [Answer]()
    weak var delegate: SingleQuestionViewControllerDelegate?
    
    @IBOutlet var questionContentLabel: UILabel!
    @IBOutlet var questionDescLabel: UILabel!
    @IBOutlet var answersTableView: UITableView!
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.cancel(by:self)
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        delegate?.logout(by: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answersTableView.dataSource = self
        answersTableView.delegate = self
        
        getSingleQuestionData()
        questionContentLabel.text = getSingleQuestion.questionContent
        questionDescLabel.text = getSingleQuestion.questionDesc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSingleQuestionData() {
        let url = URL(string: "\(apiUrl.http)api/questions/\(self.questionId)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            do {
                self.allAnswers = []
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject?] {
                    for item in jsonResult["answers"] as! [AnyObject]{
                        let singleAnswer = Answer(answerId: item["_id"] as! String, answerContent: item["answerContent"] as! String, answerDesc: item["answerDesc"] as! String, likes: item["likes"] as! Int, writer: item["writer"] as! String)
                        self.allAnswers.append(singleAnswer)
                        // send the reload data task back to the main thread
                        OperationQueue.main.addOperation {
                            self.answersTableView.reloadData()
                        }
                    }
                }
            } catch {
                print("Got error when getting single question from api")
            }
        }
        // execute the task
        task.resume()
    }
    

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = answersTableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerTableViewCell
        cell.delegate = self
        let currentAnswer = allAnswers[indexPath.row] as Answer
        cell.getCurrentAnswer = currentAnswer
        cell.writerLabel.text = currentAnswer.writer
        cell.answerContentLabel.text = currentAnswer.answerContent
        cell.answerDescLabel.text = currentAnswer.answerDesc
        cell.likesLabel.text = String(currentAnswer.likes)
        return cell
    }
    
    
    // MARK: Delegate
    func addLike(currentAnswerId: String) {
        print("Like CLICKED")
        let parameters: [String: String] = ["answerId" : currentAnswerId]
        
        let url = URL(string: "\(apiUrl.http)api/write/\(questionId)/liked")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
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
//                        print(dictionary)
                        if let error = dictionary["error"] as? [String: AnyObject] {
                            if (error["message"] != nil) {
                                print(error["message"]!)
                            }
                        }   else {
                            DispatchQueue.main.async {
//                                print("in dispatch")
                                self.getSingleQuestionData()
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

}
