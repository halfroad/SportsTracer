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
    }
    
    func acquireHealthRecords(_ completionHandler: @escaping([(name: String, icon: String, value: Double, unit: String, lastTime: Date)]) -> Void) -> Void {
        
        var records = [(name: String, icon: String, value: Double, unit: String, lastTime: Date)]()
        
        let dispatchQueue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        
        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            
            dispatchSemaphore.wait()
            
            self?.querySteps { (result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in

                let item = (name: NSLocalizedString("Number of Steps", comment: "Number of Steps"), icon: "Walking", value: recordWrittenByMobilePhone, unit: NSLocalizedString("steps", comment: "steps"), lastTime)
                
                records.append(item)
                
                dispatchSemaphore.signal()
            }
        }
        
        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            
            dispatchSemaphore.wait()
            
            self?.queryDistanceWalkingRunnings { (result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in

                let item = (name: NSLocalizedString("Walk + Runing Distance", comment: "Walk + Runing Distance"), icon: "Running", value: recordWrittenByMobilePhone, unit.unitString, lastTime)
                
                records.append(item)
                
                dispatchSemaphore.signal()
            }
        }
        
        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            
            dispatchSemaphore.wait()
            
            self?.queryHeartRate { (result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in

                let item = (name: NSLocalizedString("Heart Rate", comment: "Heart Rate"), icon: "Heartbeat", value: recordWrittenByMobilePhone, unit: NSLocalizedString("BPM", comment: "BPM"), lastTime)
                
                records.append(item)
                dispatchSemaphore.signal()
                
                completionHandler(records)
            }
        }
    }
}

// MARK -- Authorizations

extension HealthDataManager {
    
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
}

// MARK -- Queries

extension HealthDataManager {
    
    func querySteps(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double, _ unit: HKUnit, _ lastTime: Date) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.stepCount, HKUnit.count(), { (recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in
                
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime)
            })
        }
    }
    
    func queryDistanceWalkingRunnings(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double, _ unit: HKUnit, _ lastTime: Date) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            let unit = HKUnit.meterUnit(with: .kilo)
            self?.queryRecords(HKQuantityTypeIdentifier.distanceWalkingRunning, unit, { (recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime)
            })
        }
    }
    
    func queryDistanceSwimming(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double, _ unit: HKUnit, _ lastTime: Date) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            let unit = HKUnit.meterUnit(with: .kilo)
            self?.queryRecords(HKQuantityTypeIdentifier.distanceSwimming, unit, { (recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in
                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime)
            })
        }
    }
    
    func queryHeartRate(_ completionHandler: @escaping(_ isAuthorised: Bool, _ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double, _ unit: HKUnit, _ lastTime: Date) -> Void) -> Void {
        
        requestAuthorizations { [weak self] (result) in
            
            self?.queryRecords(HKQuantityTypeIdentifier.heartRate, HKUnit.count().unitDivided(by: HKUnit.minute()), { (recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime) in

                completionHandler(result, recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime)
            })
        }
    }
}

// MARK -- Query the health records.

extension HealthDataManager {
    
    func queryRecords(_ typeIdentifier: HKQuantityTypeIdentifier, _ unit: HKUnit, _ completionHandler: @escaping(_ recordWrittenByApp: Double, _ recordWrittenByMobilePhone: Double, _ unit: HKUnit, _ lastTime: Date) -> Void) {
        
        // NSSortDescriptors is used to sort the healt data
        let start = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let stop  = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let now = Date()
        guard let sampleType = HKQuantityType.quantityType(forIdentifier: typeIdentifier) else {
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
            
            var lastTime: Date = startDate ?? Date()
            
            for record in records {
                // Record written by current app.
                if record.sourceRevision.source.bundleIdentifier == Bundle.main.bundleIdentifier {
                    if record.isKind(of: HKQuantitySample.self) {
                        recordWrittenByApp = recordWrittenByApp + record.quantity.doubleValue(for: unit)
                        
                    }
                } else {
                    // Record created by mobile health sensor
                    if record.isKind(of: HKQuantitySample.self) {
                        recordWrittenByMobilePhone = recordWrittenByMobilePhone + record.quantity.doubleValue(for: unit)
                    }
                }
                
                if lastTime < record.endDate {
                    lastTime = record.endDate
                }
            }
                        
            completionHandler(recordWrittenByApp, recordWrittenByMobilePhone, unit, lastTime)
        }
    
        healthStore.execute(query)  // Start the Query
    }
}
