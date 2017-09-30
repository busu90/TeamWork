//
//  ProjectsController.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import UIKit
class ProjectsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var projectsTable: UITableView!
    @IBOutlet weak var noProjectsContainer: UIView!
    var projects: [Project] = []
    private let projectCellReuseId = "projectCell"
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if projects.count == 0{
            projects = ApiManager.sharedInstance.getLocalProjects()
        }
        projectsTable.refreshControl = UIRefreshControl()
        projectsTable.refreshControl!.attributedTitle = NSAttributedString(string: "Refresh Projects")
        projectsTable.refreshControl!.addTarget(self, action: #selector(refreshProjects), for: .valueChanged)
    }
    
    func refreshProjects(indicateProgress: Bool = false){
        noProjectsContainer.isUserInteractionEnabled = false
        ApiManager.sharedInstance.getProjects(indicateProgress: indicateProgress, completion: { [weak self](projects, err) in
            self?.noProjectsContainer.isUserInteractionEnabled = true
            self?.projectsTable.refreshControl?.endRefreshing()
            if err != nil{
                let alert = UIAlertController(title: "Error", message: "There was a problem fetching projects. \nError message:\n \(err!.localizedDescription)\n Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return;
            }else{
                let newPrj = projects != nil ? projects! : []
                self?.projects = newPrj
                if newPrj.count > 0{
                    self?.noProjectsContainer.alpha = 0
                    self?.projectsTable.alpha = 1
                }else{
                    self?.noProjectsContainer.alpha = 1
                    self?.projectsTable.alpha = 0
                }
                self?.projectsTable.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if projects.count == 0{
            projectsTable.alpha = 0
            noProjectsContainer.alpha = 1
        }else{
            projectsTable.alpha = 1
            noProjectsContainer.alpha = 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: projectCellReuseId, for: indexPath) as! ProjectCell
        cell.fillWith(project: projects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let next = storyboard?.instantiateViewController(withIdentifier: "projectDetailsController") as! ProjectDetailsController
        next.project = projects[indexPath.row]
        next.modalPresentationStyle = .overCurrentContext
        present(next, animated: false, completion: nil)
    }
    
    @IBAction func refreshUpInside(_ sender: Any) {
        refreshProjects(indicateProgress: true)
    }
}
