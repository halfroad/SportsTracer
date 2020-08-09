//
//  EntityConvertableProtocol.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/8.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

protocol EntityConvertableProtocol where Self: Decodable {
    
    associatedtype T
    
    func toEntity() -> T
}
