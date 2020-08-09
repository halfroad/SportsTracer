//
//  ModelConvertableProtocol.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/8.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import CoreData

protocol ModelConvertableProtocol where Self: NSManagedObject {
    
    associatedtype T
    
    func toModel() -> T
}
