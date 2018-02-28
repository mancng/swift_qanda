//
//  ViewController.swift
//  qanda
//
//  Created by Rachel Ng on 2/27/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit



class ShowAllViewController: UIViewController {
    
    var allQuestions: [String: Any] = [:]

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var questionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTableView.dataSource = self
        questionTableView.delegate = self
        
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
        let url = URL(string: "http://localhost:8000/api/questions/5a94a9ff4fbfb00f74f52576")
        //        let url = URL(string: "http:localhost:8000/api/questions")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult)
                    if let results = jsonResult["results"] {
                        let resultsArray = results as! NSArray
                        print(resultsArray.count)
                        print(resultsArray.firstObject)
                    }
                }
            } catch {
                print("Got error when getting data from api")
            }
        }
        // execute the task
        task.resume()
    }


}

extension UIViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        return cell
    }

}

extension UIViewController: UITableViewDelegate {
    
}

