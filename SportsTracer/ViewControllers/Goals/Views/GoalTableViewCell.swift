//
//  GoalTableViewCell.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var medalImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ type: Goal.Types, _ title: String, _ description: String, _ lastTime: String, _ completion: Int64, _ goal: Int64, _ points: Int64, _ trophy: Goal.Reward.Trophies) -> Void {
        
        var name = NSLocalizedString("Steps", comment: "Steps")
        var icon = "Walking"
        
        switch type {
            
            case .step:
                name = NSLocalizedString("Steps", comment: "Steps")
                icon = "Walking"
            
            case .walkingDistance, .runningDistance:
                name = NSLocalizedString("Walking + Running Distance", comment: "Walking + Running Distance")
                icon = "Running"
            
            default:
                name = NSLocalizedString("Steps", comment: "Steps")
                icon = "Walking"
        }
        
        self.nameLabel.text = name
        self.iconImageView.image = UIImage(named: icon)
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.lastTimeLabel.text = lastTime
        
        let completion = Int(completion)
        
        let completionAttributedString = NSMutableAttributedString(string: "\(completion) ", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        
        self.completionLabel.attributedText = completionAttributedString
        
        let goal = Int(goal)
        
        let goalAttributedString = NSMutableAttributedString(string: "\(goal) ", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        
        self.goalLabel.attributedText = goalAttributedString
        
        let percentage = Float(Float(completion) / Float(goal))
        self.progressView.progress = Float(percentage)
        
        let pointsAttributedString = NSMutableAttributedString(string: "\(points) ", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        
        self.pointsLabel.attributedText = pointsAttributedString
        
        var medal = "BronzeMedal"
        
        switch trophy {
            
            case .bronzeMedal:
                medal = "BronzeMedal"
            
            case .silverMedal:
                medal = "SilverMedal"
            
            case .goldMedal:
                medal = "GoldMedal"
            
            case .zombieHand:
                medal = "ZombieHand"
            
            default:
                medal = "BronzeMedal"
        }
        self.medalImageView.image = UIImage(named: medal)
    }
}
