//
//  LoginController.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class LoginController: UIViewController{
    @IBOutlet weak var credsContainer: UIView!
    @IBOutlet weak var token: UITextField!
    @IBOutlet weak var team: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logoBottom: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoBottomFinal: NSLayoutConstraint!
    @IBOutlet weak var logoWidthFinal: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        token.attributedPlaceholder = NSAttributedString(string:"Api Token", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        team.attributedPlaceholder = NSAttributedString(string:"Team Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ApiManager.sharedInstance.isLoggedIn(){
            performSegue(withIdentifier: "projectsSegue", sender: self)
        }else{
            logoBottom.isActive = false
            logoWidth.isActive = false
            logoBottomFinal.isActive = true
            logoWidthFinal.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (flag) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.credsContainer.alpha = 1
                    self.login.alpha = 1
                })
            }
        }
    }
    @IBAction func loginUpInside(_ sender: Any) {
        if token.text != nil && token.text!.characters.count > 0 && team.text != nil && team.text!.characters.count > 0{
            login.isUserInteractionEnabled = false
            ApiManager.sharedInstance.setup(apiKey: token.text!, teamName: team.text!)
            ApiManager.sharedInstance.getProjects(completion: { [weak self](projects, err) in
                self?.login.isUserInteractionEnabled = true
                if err != nil{
                    let alert = UIAlertController(title: "Error", message: "There was a problem logging you in. \nError message:\n \(err!.localizedDescription)\n Please check your credentials and try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    return;
                }else{
                    ApiManager.sharedInstance.saveCreds(apiKey: self?.token.text, team: self?.team.text)
                    self?.token.text = ""
                    self?.team.text = ""
                    let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "projectsController") as! ProjectsController
                    next.projects = projects != nil ? projects! : []
                    self?.navigationController?.pushViewController(next, animated: true)
                }
            })
        }
    }
}
