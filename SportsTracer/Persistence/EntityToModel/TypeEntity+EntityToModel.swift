//
//  TypeEntity+EntityToModel.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/8.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

extension TypeEntity: ModelConvertableProtocol {
    
    typealias T = Goal.Types
    
    func toModel() -> Goal.Types {
        
        if let name = self.name, let type = Goal.Types(rawValue: name) {
            return type
        }
        
        return Goal.Types.unknown
    }
}
