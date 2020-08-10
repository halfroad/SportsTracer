//
//  Type+ModelToEntity.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/10.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

extension Goal.Types: EntityConvertableProtocol {
    
    typealias T = TypeEntity
    
    func toEntity() -> TypeEntity? {
        
        return DataManager.createType(self.rawValue)
    }
}
