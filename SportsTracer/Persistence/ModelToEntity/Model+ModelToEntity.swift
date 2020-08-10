//
//  Model+ModelToEntity.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//


extension Goal: EntityConvertableProtocol {
    
    typealias T = GoalEntity
    
    func toEntity() -> GoalEntity? {
        
        return DataManager.createGoal(self.id, self.title, self.description, self.type?.rawValue, self.value, self.reward?.trophy?.rawValue, self.reward?.points)
    }
}
