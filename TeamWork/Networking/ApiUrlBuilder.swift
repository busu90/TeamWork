//
//  ApiUrlBuilder.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import Alamofire
enum Router: URLRequestConvertible {
    static var teamName:String = ""
    private var baseUrlString: String {
        get {
            return "https://\(Router.teamName).teamwork.com/"
        }
    }
    
    //Auth
    case getProjects
    case getTasks(projectId: String)
    
    private func getPathValues() -> (HTTPMethod, String, [String: AnyObject]?, ParameterEncoding){
        switch self {
        case .getProjects:
            return (.get, "projects.json", nil, URLEncoding.default)
        case .getTasks(let projectId):
            return (.get, "/projects/\(projectId)/tasks.json", nil, URLEncoding.default)
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = NSURL(string:baseUrlString)!
        let urlRequest = NSMutableURLRequest(url: url.appendingPathComponent(getPathValues().1)!)
        urlRequest.httpMethod = getPathValues().0.rawValue
        let encoding = getPathValues().3
        
        return try encoding.encode(urlRequest as URLRequest, with: getPathValues().2)
    }
}
