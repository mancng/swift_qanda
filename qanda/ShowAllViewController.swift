//
//  ViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/27/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol ShowAllViewControllerDelegate: class {
    
}

class ShowAllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateQuestionViewControllerDelegate, CreateAnswerViewControllerDelegate, SingleQuestionViewControllerDelegate{

    var allQuestions = [Question]()
    var singleQuestion = Question()
    var questionId: String = ""
    var userName: String = ""
    weak var delegate: ShowAllViewControllerDelegate?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var questionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTableView.dataSource = self
        questionTableView.delegate = self
        
        // Get current user
        let url = URL(string: "http://localhost:8000/api/users/current")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                print("This is from ShowAllViewController")
                print(jsonResult!["name"])
                print("This ends in ShowAllViewController")
                self.userName = jsonResult!["name"] as! String
                OperationQueue.main.addOperation {
                    self.nameLabel.text = "Hi \(jsonResult!["name"] as! String)!"
                    self.getQuestionsData()
                }
            } catch {
                print("Got error when getting user from api")
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getQuestionsData(){
        let url = URL(string: "http://localhost:8000/api/questions")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject?] {
//                    print(jsonResult)
                    if let result = jsonResult["questions"] {
                        let resultsArray = result as! NSArray
                        for item in jsonResult["questions"] as! [AnyObject]{
                            let singleQuestion = Question(questionId: item["_id"] as! String, questionContent: item["questionContent"] as! String, questionDesc: item["questionDesc"] as! String, answers: item["answers"] as? [AnyObject])
                            self.allQuestions.append(singleQuestion)
                            OperationQueue.main.addOperation {
                                self.questionTableView.reloadData()
                            }
                        }
                    }
                }
            } catch {
                print("Got error when getting data from api")
            }
        }
        // execute the task
        task.resume()
    }
    
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createQuestionSegue" {
            let navigationController = segue.destination as! UINavigationController
            let createViewController = navigationController.topViewController as! CreateQuestionViewController
            createViewController.delegate = self
        } else if segue.identifier == "createAnswerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let createAnswerViewController = navigationController.topViewController as! CreateAnswerViewController
            createAnswerViewController.delegate = self
            createAnswerViewController.questionId = self.questionId
            createAnswerViewController.theQuestion = self.singleQuestion
            createAnswerViewController.userName = self.userName
        } else if segue.identifier == "showSingleSegue" {
            let navigationController = segue.destination as! UINavigationController
            let singleQuestionViewController = navigationController.topViewController as!
            SingleQuestionViewController
            singleQuestionViewController.delegate = self
            singleQuestionViewController.questionId = self.questionId
            singleQuestionViewController.getSingleQuestion = self.singleQuestion
        }
    }
    
    
    // MARK: Delegate
    func createQuestion(by controller: UIViewController, theQuestionContent: String!, theQuestionDesc: String?) {
        let questionToCreate: [String: Any] = ["questionContent": theQuestionContent, "questionDesc": theQuestionDesc]
        print("**********************")
        print(questionToCreate)
        
        let url = URL(string: "http://localhost:8000/api/questions")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: questionToCreate, options: .prettyPrinted)
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
//                                    self.getQuestionsData()
                                    self.dismiss(animated: true, completion: nil)
                                    
//                                    self.performSegue(withIdentifier: "showAllSegue", sender: self)
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
        dismiss(animated: true, completion: nil)
    }
    
    func createAnswer(by controller: UIViewController, answerContent: String, answerDesc: String, theQuestionId: String, writer: String) {
        
        var answerToCreate = [String:[String:AnyObject]]()
        
        answerToCreate = ["answers": ["answerContent": answerContent as AnyObject, "answerDesc": answerDesc as AnyObject, "writer": writer as AnyObject]]
        
        let url = URL(string: "http://localhost:8000/api/write/\(theQuestionId)")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: answerToCreate, options: .prettyPrinted)
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
                                    self.dismiss(animated: true, completion: nil)
                                    self.getQuestionsData()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancel(by controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func logout(by controller: UIViewController) {
        // need to build out!!
        dismiss(animated: true, completion: nil)
    }
    
    func addLike(by controller: UIViewController, quesitonId: String, answerId: String) {
        // need to build out!!
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionTableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let currentQuestion = allQuestions[indexPath.row] as Question
        cell.contentLabel.text = currentQuestion.questionContent
        let numOfAnswers = currentQuestion.answers! as NSArray
        cell.answerCountLabel.text = String(describing: numOfAnswers.count)
        cell.accessoryType = .detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        singleQuestion = self.allQuestions[indexPath.row] as Question
        questionId = singleQuestion.questionId
        
//        performSegue(withIdentifier: "showSingleSegue", sender: indexPath)
        performSegue(withIdentifier: "createAnswerSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("I got clicked")
        singleQuestion = self.allQuestions[indexPath.row] as Question
        questionId = singleQuestion.questionId
        self.performSegue(withIdentifier: "showSingleSegue", sender: indexPath)
        
    }
    
    


}


