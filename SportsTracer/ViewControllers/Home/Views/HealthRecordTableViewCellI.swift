//
//  HealthRecordTableViewCell.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

class HealthRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ name: String, _ lastTime: String, _ value: Float, _ unit: String) -> Void {
        
        self.titleLabel.text = name
        self.lastTimeLabel.text = lastTime
        
        let valueAttributedString = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle)])
        let unitAttributedString = NSMutableAttributedString(string: unit, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        valueAttributedString.append(unitAttributedString)
        
        self.valueLabel.attributedText = valueAttributedString
    }

}
