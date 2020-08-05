//
//  GoalService.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/5.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

class GoalService: SecuredNetworkService {
    
    static let AcquireGoalsEndpoint = "/_ah/api/myApi/v1/goals"
    
    func acquireGoals(_ userName: String, _ completionHandler: @escaping ((_ result: Bool, _ goals: [Goal], _ error: Error?) -> Void)) -> Void {
        
        // Here the error messages can defined more user friendly, the error messages here are only for demostration for the error handling.
        
        if let url = URL (string: Settings.Host + GoalService.AcquireGoalsEndpoint) {
            
            super.request(url: url, (key: "AccessToken", value: UUID().uuidString)) { (data, urlResponse, error) in
                
                if let httpURLResponse = urlResponse as? HTTPURLResponse, let data = data {
                    
                    let result = httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300
                    
                    if result {
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        if let goalsResponse = try? decoder.decode(GoalsPayload.self, from: data) {
                            
                            completionHandler (false, goalsResponse.items, nil)
                        } else {
                            let error = NSError (domain: ErrorHandling.errorDomain, code: ErrorHandling.errorDomainDefaultCode, userInfo: [NSLocalizedDescriptionKey : "Invalid JSON"])
                            completionHandler (false, [Goal](), error)
                        }
                    
                    } else {
                        
                        let error = NSError (domain: ErrorHandling.errorDomain, code: ErrorHandling.errorDomainDefaultCode, userInfo: [NSLocalizedDescriptionKey : "Request or response is invalid"])
                        completionHandler (false, [Goal](), error)
                        
                        completionHandler (false, [Goal](), nil)
                    }
                    
                } else {
                    if let error = error {
                        completionHandler (false, [Goal](), error)
                    } else {
                        let error = NSError (domain: ErrorHandling.errorDomain, code: ErrorHandling.errorDomainDefaultCode, userInfo: [NSLocalizedDescriptionKey : "Invalid response"])
                        completionHandler (false, [Goal](), error)
                    }
                }
            }
            
        } else {
            let error = NSError (domain: ErrorHandling.errorDomain, code: ErrorHandling.errorDomainDefaultCode, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
            completionHandler (false, [Goal](), error)
        }
    }
    
}
