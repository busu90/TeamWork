//
//  Project.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import ObjectMapper
class Project:NSObject, Mappable, NSCoding {
    var logo: String?
    var name: String?
    var id: String?
    var desc: String?
    var createdOn: String?
    var replyByEmailEnabled: Bool?
    var status: String?
    var showAnnouncement: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        self.logo = aDecoder.decodeObject(forKey: "logo") as! String?
        self.name = aDecoder.decodeObject(forKey: "name") as! String?
        self.id = aDecoder.decodeObject(forKey: "id") as! String?
        self.desc = aDecoder.decodeObject(forKey: "desc") as! String?
        self.createdOn = aDecoder.decodeObject(forKey: "createdOn") as! String?
        self.replyByEmailEnabled = aDecoder.decodeObject(forKey: "replyByEmailEnabled") as! Bool?
        self.status = aDecoder.decodeObject(forKey: "status") as! String?
        self.showAnnouncement = aDecoder.decodeObject(forKey: "showAnnouncement") as! Bool?
    }
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(logo, forKey: "logo")
        coder.encode(id, forKey: "id")
        coder.encode(desc, forKey: "desc")
        coder.encode(createdOn, forKey: "createdOn")
        coder.encode(replyByEmailEnabled, forKey: "replyByEmailEnabled")
        coder.encode(status, forKey: "status")
        coder.encode(showAnnouncement, forKey: "showAnnouncement")
    }
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        logo <- map["logo"]
        name <- map["name"]
        id <- map["id"]
        desc <- map["description"]
        createdOn <- map["created-on"]
        replyByEmailEnabled <- map["replyByEmailEnabled"]
        status <- map["status"]
        showAnnouncement <- map["show-announcement"]
    }
}
