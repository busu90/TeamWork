//
//  ProjectCell.swift
//  TeamWork
//
//  Created by Andrei Busuioc on 9/30/17.
//  Copyright © 2017 Andrei Busuioc. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class ProjectCell: UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.layer.cornerRadius = icon.frame.size.width / 2
    }
    func fillWith(project: Project){
        if let logo = project.logo{
            icon.sd_setImage(with: URL(string: logo), placeholderImage: #imageLiteral(resourceName: "NoProjectsIcon"))
        }else{
            icon.image = #imageLiteral(resourceName: "NoProjectsIcon")
        }
        name.text = project.name
        desc.text = project.desc
    }
}
