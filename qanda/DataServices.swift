//
//  DataServices.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import Foundation

struct User {
    static var name = ""
}

class Question : NSDictionary {
    var questionContent: String!
    var questionDesc: String!
    var answers : [AnyObject] = []
}
