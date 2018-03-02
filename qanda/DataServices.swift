//
//  DataServices.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import Foundation

struct User {
    let name: String
}

struct Question {
    var questionId: String!
    var questionContent: String!
    var questionDesc: String!
    var answers: [AnyObject]? = []
}

struct Answer {
    var answerId: String!
    var answerContent: String!
    var answerDesc: String!
    var likes: Int = 0
    var writer: String!
}
