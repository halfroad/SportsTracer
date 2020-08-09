//
//  GoalEntity+EntityToModel.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/8.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import CoreData

extension GoalEntity: ModelConvertableProtocol {
    
    typealias T = Goal
    
    func toModel() -> Goal {
        
        return Goal(self.id, self.title, self.remark,self.type?.toModel() , Int(self.value),self.reward?.toModel())
    }
}
