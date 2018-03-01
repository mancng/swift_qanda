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

class ShowAllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CreateQuestionViewControllerDelegate {

    var allQuestions = [Question]()
    var singleQuestion = Question()
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
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print(jsonResult)
                self.getQuestionsData()
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
        //        let url = URL(string: "http:localhost:8000/api/questions")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult)
                    if let results = jsonResult["questions"] {
                        let resultsArray = results as! NSArray
                        self.allQuestions = resultsArray as! [Question]
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
        }
    }
    
    // MARK: Delegate
    func createQuestion(by controller: UIViewController, questionContent: String?, questionDesc: String?) {
        let questionToCreate: [String: Any] = ["questionContent": questionContent, "questionDesc": questionDesc]
        dismiss(animated: true, completion: nil)
    }
    
    func cancel(by controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func logout(by controller: UIViewController) {
        // need to build out!!
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionTableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        //        let currentQuestion = allQuestions[indexPath.row] as NSDictionary
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let cell = questionTableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
    //        return cell.frame.size.height
    //
    //    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        singleQuestion = allQuestions[indexPath.row] as Question
    //        performSegue(withIdentifier: 'ShowSingleQuestion', sender: indexPath)
    //    }


}


