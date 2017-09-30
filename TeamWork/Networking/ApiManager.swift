//
//  ApiManager.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import LinearProgressBarMaterial
import SwiftKeychainWrapper
class ApiManager{
    private let tokenKeychainKey = "apiKey"
    private let teamDefaultsKey = "team"
    private let projectsDefaultsKey = "projects"
    static let sharedInstance = ApiManager()
    private var apiKey: String = ""
    private let progress = LinearProgressBar()
    public func setup(apiKey: String, teamName: String){
        Router.teamName = teamName
        self.apiKey = apiKey
    }
    init() {
        if let key = KeychainWrapper.standard.string(forKey: tokenKeychainKey){
            self.apiKey = key
        }
        if let team = UserDefaults.standard.string(forKey: teamDefaultsKey){
            Router.teamName = team
        }
    }
    public func isLoggedIn() -> Bool{
        if apiKey.characters.count > 0 && Router.teamName.characters.count > 0{
            return true
        }else{
            return false
        }
    }
    public func saveCreds(apiKey: String?, team: String?){
        if apiKey == nil || team == nil{
            return
        }
        KeychainWrapper.standard.set(apiKey!, forKey: tokenKeychainKey)
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(team!, forKey: teamDefaultsKey)
        userDefaults.synchronize()
    }
    private func saveLocalProjects(projects: [Project]){
        let projectsData = NSKeyedArchiver.archivedData(withRootObject: projects)
        let userDefaults = UserDefaults.standard
        userDefaults.set(projectsData, forKey: projectsDefaultsKey)
        userDefaults.synchronize()
    }
    public func getLocalProjects() -> [Project]{
        if let projectsData = UserDefaults.standard.object(forKey: projectsDefaultsKey) as? NSData{
            if let projectsArray = NSKeyedUnarchiver.unarchiveObject(with: projectsData as Data) as? [Project] {
                return projectsArray
            }
        }
        return []
    }
    public func getProjects(indicateProgress: Bool = true, completion: @escaping (_ projects: [Project]?, _ error: Error?) -> Void){
        if indicateProgress{
            progress.startAnimation()
        }
        Alamofire.request(Router.getProjects).authenticate(user: apiKey, password: "").validate().responseArray(keyPath: "projects"){ (response: DataResponse<[Project]>) in
            if indicateProgress{
                self.progress.stopAnimation()
            }
            if let err = response.error{
                completion(nil, err)
            }else if let projectsArray = response.result.value{
                self.saveLocalProjects(projects: projectsArray)
                completion(projectsArray, nil)
            }else{
                completion(nil, nil)
            }
        }
    }
    public func getTasks(projectId: String, completion: @escaping (_ tasks: [Task]?, _ error: Error?) -> Void){
        progress.startAnimation()
        Alamofire.request(Router.getTasks(projectId: projectId)).validate().responseArray(keyPath: "todo-items"){ (response: DataResponse<[Task]>) in
            self.progress.stopAnimation()
            if let err = response.error{
                completion(nil, err)
            }else if let tasksArray = response.result.value{
                completion(tasksArray, nil)
            }else{
                completion(nil, nil)
            }
        }
    }
}
