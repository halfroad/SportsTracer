//
//  HealthStoreContainer.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/6.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import HealthKit

protocol HealthStoreContainer {
    // A required property that contains the health store.
    var healthStore: HKHealthStore! { get set }
}
