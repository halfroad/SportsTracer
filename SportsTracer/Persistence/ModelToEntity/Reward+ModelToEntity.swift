//
//  Reward+ModelToEntity.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/10.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

extension Goal.Reward: EntityConvertableProtocol {
    
    typealias T = RewardEntity
    
    func toEntity() -> RewardEntity? {
        
        if let trophy = self.trophy, let points = self.points {
            return DataManager.createReward(trophy.rawValue, points)
        }
        
        return nil
    }
}
