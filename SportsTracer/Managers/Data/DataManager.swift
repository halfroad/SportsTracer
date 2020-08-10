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
        
        return DataManager.createGoal(goal.id, goal.title, goal.description, goal.type?.rawValue, goal.value, goal.reward?.trophy?.rawValue, goal.reward?.points)
    }
    
    class func createGoal(_ id: String? = "", _ title: String? = "", _ remark: String? = "", _ type: String? = "", _ value: Int64? = -1, _ trophy: String? = "", _ points: Int64? = -1) -> GoalEntity {
                
        if let id = id, let goalEntity = DataManager.findGoal(by: id) {
            DataManager.delete(goalEntity)
        }
        
        let goalEntity: GoalEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: GoalEntity.self), into: PersistenceManager.shared.persistentContainer.viewContext) as! GoalEntity
        
        goalEntity.id = id
        goalEntity.title = title
        goalEntity.remark = remark
        goalEntity.value = value ?? -1
        
        if let name = type {
            
            if let typeEntity = DataManager.findType(name) {
                DataManager.delete(typeEntity)
            }
            
            let newType = Goal.Types(rawValue: name)
            goalEntity.type = newType?.toEntity()
        }
        
        if let trophy = trophy, let points = points, points > 0 {
            
            if let rewardEntity = DataManager.findReward(trophy, Int(points)) {
                
                goalEntity.reward = rewardEntity
                DataManager.delete(rewardEntity)
            }
            
            let newReward = Goal.Reward(Goal.Reward.Trophies(rawValue: trophy), points)
            goalEntity.reward = newReward.toEntity()
        }
        
        PersistenceManager.shared.saveContext()
        
        return goalEntity
    }
}

// MARK: - Goal Entity

extension DataManager {
    
    class func findGoal (by id: String) -> GoalEntity? {
        
        let predicate = NSPredicate(format: "id = %@", id)
        if let goals: [GoalEntity] = EntityManager.fetchEntity(with: "GoalEntity", predicate: predicate, sortDescriptors: nil), goals.count > 0 {
            
            return goals.last
        }
        
        return nil
    }
    
    class func findGoals () -> [GoalEntity] {
        
        if let goals: [GoalEntity] = EntityManager.fetchEntity(with: "GoalEntity", predicate: nil, sortDescriptors: nil) {
            
            return goals
        }
        
        return [GoalEntity]()
    }
}

// MARK: - Type Entity

extension DataManager {
    
    class func findType (_ name: String) -> TypeEntity? {
        
        let predicate = NSPredicate(format: "name = %@", name)
        if let types:[TypeEntity] = EntityManager.fetchEntity(with: "TypeEntity", predicate: predicate, sortDescriptors: nil), types.count > 0 {
            
            return types.last
        }
        
        return nil
    }
    
    class func createType (_ name: String) -> TypeEntity {
        
        let typeEntity: TypeEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: TypeEntity.self), into: PersistenceManager.shared.persistentContainer.viewContext) as! TypeEntity
        
        typeEntity.name = name
        
        return typeEntity
    }
}

// MARK: - Reward Entity

extension DataManager {
    
    class func findReward (_ trophy: String, _ points: Int) -> RewardEntity? {
        
        let predicate = NSPredicate(format: "trophy = %@ AND points = %@", argumentArray: [trophy, points])
        if let rewards: [RewardEntity] = EntityManager.fetchEntity(with: "RewardEntity", predicate: predicate, sortDescriptors: nil), rewards.count > 0 {
            
            return rewards.last
        }
        
        return nil
    }
    
    class func createReward (_ trophy: String, _ points: Int64) -> RewardEntity {
        
        let rewardEntity: RewardEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: RewardEntity.self), into: PersistenceManager.shared.persistentContainer.viewContext) as! RewardEntity
        
        rewardEntity.trophy = trophy
        rewardEntity.points = points
        
        return rewardEntity
    }
}

// MARK: - Data Purge

extension DataManager {
    
    class func delete<T: NSManagedObject>(_ object: T) -> Void {
        
        PersistenceManager.shared.persistentContainer.viewContext.delete(object)
        PersistenceManager.shared.saveContext()
    }
}
