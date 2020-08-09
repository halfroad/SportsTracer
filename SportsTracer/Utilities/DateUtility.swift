//
//  DateUtility.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

extension Date {
    
    func toHourMinute() -> String {
        
        let dateFormatter = DateFormatter()
        // To convert the date into an HH:mm format
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
