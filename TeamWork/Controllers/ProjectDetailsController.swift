//
//  ProjectDetailsController.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import UIKit
class ProjectDetailsController: UIViewController{
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cardVerticalCenter: NSLayoutConstraint!
    
    var project: Project!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lg = project.logo{
            logo.sd_setImage(with: URL(string: lg), placeholderImage: #imageLiteral(resourceName: "NoProjectsIcon"))
        }else{
            logo.image = #imageLiteral(resourceName: "NoProjectsIcon")
        }
        titleLbl.text = project.name
        descLbl.text = project.desc
        cardVerticalCenter.constant = -self.view.frame.height
        self.view.layoutIfNeeded()
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.black.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardVerticalCenter.constant = 0
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.layoutIfNeeded()
        }) { (fin) in
            self.cardVerticalCenter.constant = -30
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (fin) in
                self.cardVerticalCenter.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.closeBtn.alpha = 1
                })
            }
        }
    }
    @IBAction func closeUpInside(_ sender: Any) {
        cardVerticalCenter.constant = -self.view.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (fin) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
