//
//  DataManager.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import CoreData

class DataManager: NSObject {
    
    class func createGoal(_ goal: Goal) -> GoalEntity {
        
        return DataManager.createGoal(goal.id, goal.title, goal.description, goal.type?.rawValue, goal.value, goal.reward.trophy?.rawValue, goal.reward.points)
    }
    
    class func createGoal(_ id: String? = "", _ title: String? = "", _ remark: String? = "", _ type: String? = "", _ value: Int64? = -1, _ trophy: String? = "", _ points: Int64? = -1) -> GoalEntity {
                
        if let id = id, let goalEntity = DataManager.findGoal(id) {
            
            return goalEntity
            
        } else {
            
            let goalEntity: GoalEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: GoalEntity.self), into: PersistenceManager.shared.persistentContainer.viewContext) as! GoalEntity
            
            goalEntity.id = id
            goalEntity.title = title
            goalEntity.remark = remark
            goalEntity.value = value ?? -1
            
            if let name = type, let typeEntity = DataManager.findType(name) {
                goalEntity.type = typeEntity
            }
            
            if let trophy = trophy, let points = points, points > 0, let rewardEntity = DataManager.findReward(trophy, Int(points)) {
                goalEntity.reward = rewardEntity
            }
            
            return goalEntity
        }
    }
}

// MARK: - Goal Entity

extension DataManager {
    
    class func findGoal (_ id: String) -> GoalEntity? {
        
        let predicate = NSPredicate(format: "id = %@", [id])
        if let goals: [GoalEntity] = EntityManager.fetchEntity(with: "GoalEntity", predicate: predicate, sortDescriptors: nil), goals.count > 0 {
            
            return goals.first
        }
        
        return nil
    }
}

// MARK: - Type Entity

extension DataManager {
    
    class func findType (_ name: String) -> TypeEntity? {
        
        let predicate = NSPredicate(format: "name = %@", [name])
        if let types:[TypeEntity] = EntityManager.fetchEntity(with: "TypeEntity", predicate: predicate, sortDescriptors: nil), types.count > 0 {
            
            return types.first
        }
        
        return nil
    }
}

// MARK: - Reward Entity

extension DataManager {
    
    class func findReward (_ trophy: String, _ points: Int) -> RewardEntity? {
        
        let predicate = NSPredicate(format: "trophy = %@ AND points = %@", [trophy, points])
        if let rewards: [RewardEntity] = EntityManager.fetchEntity(with: "RewardEntity", predicate: predicate, sortDescriptors: nil), rewards.count > 0 {
            
            return rewards.first
        }
        
        return nil
    }
}
