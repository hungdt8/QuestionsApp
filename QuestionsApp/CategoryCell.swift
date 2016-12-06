//
//  CategoryCell.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/30/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Nuke

class CategoryCell: ParentCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var category: ExamCategory! {
        didSet {
            categoryNameLabel.text = category.name
            
            if let image = category.image where !image.isEmpty, let url = NSURL(string: image) {
                imgView.nk_setImageWith(url)
            } else {
                imgView.image = UIImage(named: "place-holder")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 5.0
        imgView.layer.masksToBounds = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
