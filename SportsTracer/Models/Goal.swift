//
//  Goal.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/5.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

struct GoalsPayload: Decodable {
    
    var items = [Goal]()
    var nextPageToken: String = ""
    
    enum CodingKeys: String, CodingKey {
        case items // The top level "items" key
        case nextPageToken
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        items = try values.decode([Goal].self, forKey: .items)
        nextPageToken = try values.decode(String.self, forKey: .nextPageToken)
    }
}

struct Goal: Decodable {
    
    var id: String? = "-1"
    var title: String? = ""
    var description: String? = ""
    
    enum Types: String, CodingKey {
        case unknown = "unknown"
        case step = "step"
        case walkingDistance = "walking_distance"
        case runningDistance = "running_distance"
    }
    
    var type: Types? = .unknown
    var value: Int64? = -1
    
    struct Reward: Decodable {
        
        enum Trophies: String, CodingKey {
            case unknown = "unknown"
            case bronzeMedal = "bronze_medal"
            case silverMedal = "silver_medal"
            case goldMedal = "gold_medal"
            case zombieHand = "zombie_hand"
        }
        
        var trophy: Trophies? = .unknown
        var points: Int64? = 0
        
        enum CodingKeys: String, CodingKey {
            case trophy, points
        }
        
        init(_ trophy: Trophies? = .unknown, _ points: Int64? = -1) {
            self.trophy = trophy
            self.points = points
        }
        
        init(from decoder: Decoder) throws {
        
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            trophy = Goal.Reward.Trophies(rawValue: try values.decode(String.self, forKey: .trophy)) ?? .unknown
            points = Int64(try values.decode(Int.self, forKey: .points))
        }
    }
    
    var reward: Reward? = Reward()
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, type, goal, reward
    }
    
    init(_ id: String? = "", _ title: String? = "", _ description: String? = "", _ type: Types? = .unknown, _ value: Int64? = -1, _ reward: Reward? = Reward()) {
        
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.value = value
        self.reward = reward
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        type = Goal.Types(rawValue: try values.decode(String.self, forKey: .type)) ?? .unknown
        value = try values.decode(Int64.self, forKey: .goal)
        reward = try values.decode(Reward.self, forKey: .reward)
    }
}

/*
 
 {
  "items": [
   {
    "id": "1000",
    "title": "Easy walk steps",
    "description": "Walk 500 steps a day",
    "type": "step",
    "goal": 500,
    "reward": {
     "trophy": "bronze_medal",
     "points": 5
    }
   },
   {
    "id": "1001",
    "title": "Medium walk steps",
    "description": "Walk 1000 steps a day",
    "type": "step",
    "goal": 1000,
    "reward": {
     "trophy": "silver_medal",
     "points": 10
    }
   },
   {
    "id": "1002",
    "title": "Hard walk steps",
    "description": "Walk 6000 steps a day",
    "type": "step",
    "goal": 6000,
    "reward": {
     "trophy": "gold_medal",
     "points": 20
    }
   },
   {
    "id": "1003",
    "title": "Walk some distance",
    "description": "Take a walk for 1 kilometer",
    "type": "walking_distance",
    "goal": 1000,
    "reward": {
     "trophy": "bronze_medal",
     "points": 5
    }
   },
   {
    "id": "1004",
    "title": "Quick Run",
    "description": "Burn that donut by running 1 kilometer",
    "type": "running_distance",
    "goal": 1000,
    "reward": {
     "trophy": "silver_medal",
     "points": 5
    }
   },
   {
    "id": "1005",
    "title": "Medium Run",
    "description": "Zombie apocalypse may come any day soon, be prepared for the occasion",
    "type": "running_distance",
    "goal": 5000,
    "reward": {
     "trophy": "zombie_hand",
     "points": 43
    }
   }
  ],
  "nextPageToken": "not used"
 }
 
 */
