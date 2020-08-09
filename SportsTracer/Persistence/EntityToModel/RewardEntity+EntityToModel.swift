//
//  RewardEntity+EntityToModel.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/8.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

extension RewardEntity: ModelConvertableProtocol {
    
    typealias T = Goal.Reward
    
    func toModel() -> Goal.Reward {
        
        var reward = Goal.Reward()
        
        if let trophy = self.trophy {
            reward.trophy = Goal.Reward.Trophies(rawValue: trophy)
        }
        
        reward.points = points
        
        return reward
    }
}
