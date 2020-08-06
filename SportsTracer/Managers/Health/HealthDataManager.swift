//
//  HealthDataManager.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/5.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit
import HealthKit

class HealthDataManager: NSObject {
    
    static let shared = HealthDataManager()
    private let healthStore: HKHealthStore

    override init() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        healthStore = HKHealthStore()
        
        // https://www.jianshu.com/p/04578f47efc0
        // https://developer.apple.com/documentation/healthkit/samples/reading_and_writing_healthkit_series_data
        //https://www.jianshu.com/p/62e137e0ae25
    }
    
    func assignHealthStore(_ rootViewController: UIViewController) {
    
    // Enumerate the view controller hierarchy and set the health store where appropriate.
        
        rootViewController.enumerateHierarchy { viewController in
            guard var healthStoreContainer = viewController as? HealthStoreContainer else { return }
            healthStoreContainer.healthStore = healthStore
        }
    }
    func requestAuthorizations(_ authorisedHandler: ((_ isAuthorised: Bool) -> Void)? = nil) {

        // Read Health Data
        let typesRead = Set([HKObjectType.workoutType(), // Walking and running distance
            HKObjectType.quantityType(forIdentifier: .stepCount)!, // Steps
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,  // Activity Energy Consumption
            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,  // Distance to ride a bicycle
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,  // distance Walking Running
            HKObjectType.quantityType(forIdentifier: .heartRate)!])  // Heart Beat
        // Write Health Data
        let typesWrite = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore.requestAuthorization(toShare: typesRead, read: typesWrite, completion: { (success, error) in
            
            if let handler = authorisedHandler {
                handler(success)
            }
        })
    }
    
    func querySteps(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.stepCount, { (recordWrittenByApp, recordWrittenByMobilePhone) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone)
            })
        }
    }
    
    func queryDistanceWalkingRunnings(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.distanceWalkingRunning, { (recordWrittenByApp, recordWrittenByMobilePhone) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone)
            })
        }
    }
    
    func queryDistanceSwimming(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.distanceSwimming, { (recordWrittenByApp, recordWrittenByMobilePhone) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone)
            })
        }
    }
    
    func queryHeartRate(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.heartRate, { (recordWrittenByApp, recordWrittenByMobilePhone) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone)
            })
        }
    }
}

extension HealthDataManager {
    
    func queryRecords(_ typeIdentifier: HKQuantityTypeIdentifier, _ completionHandler: @escaping(_ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double) -> Void) {
        
        HKQuantityType.quantityType(forIdentifier: typeIdentifier)
        // NSSortDescriptors is used to sort the healt data
        let start = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let stop  = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let now = Date()
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            fatalError("*** This method should never fail ***")
        }
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        let endDate = calendar.date(from: dateComponent) // End date for the query
        
        dateComponent.hour = 0
        dateComponent.minute = 0
        dateComponent.second = 0
    
        let startDate = calendar.date(from: dateComponent)    // Start date for the query, from 0 o'clock
    
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictStartDate)
        
        var recordWrittenByMobilePhone: Double = 0  // Steps recorded by health sensor on mobile phone
        var recordWrittenByApp: Double = 0  // Steps written by app
    
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [start, stop]) { (query, results, error) in
            
            // Callback of query.
            guard let records = results as? [HKQuantitySample] else {
                // fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(String(describing: error?.localizedDescription))");
                print("error to acquire steps ---> \(String(describing: error?.localizedDescription))")
                return
            }
            
            for record in records {
                // Record written by current app.
                if record.sourceRevision.source.bundleIdentifier == Bundle.main.bundleIdentifier {
                    print("Record written by app")
                    if record.isKind(of: HKQuantitySample.self) {
                        recordWrittenByApp = recordWrittenByApp + record.quantity.doubleValue(for: HKUnit.count())
                    }
                } else {
                    // Record created by mobile health sensor
                    if record.isKind(of: HKQuantitySample.self) {
                        recordWrittenByMobilePhone = recordWrittenByMobilePhone + record.quantity.doubleValue(for: HKUnit.count())
                    }
                }
            }
            
            completionHandler(recordWrittenByApp, recordWrittenByMobilePhone)
        }
    
        healthStore.execute(query)   //开始查询
    }
}
