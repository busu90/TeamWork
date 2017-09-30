//
//  Task.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import ObjectMapper
class Task: Mappable {
    var avatar: String?
    var status: String?
    var id: String?
    var content: String?
    var createdOn: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        avatar <- map["creator-avatar-url"]
        status <- map["status"]
        id <- map["id"]
        content <- map["content"]
        createdOn <- map["created-on"]
    }
}
