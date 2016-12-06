//
//  YourExamCell.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 11/19/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class YourExamCell: ExamCell {

//    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressLabel.textColor = UIColor(hex: "c6c6c6")
        progressLabel.textAlignment = .Right
        
//        progressBar.progress = 0
//        progressBar.tintColor = Constants.Color.colorProgsressAnswer
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
