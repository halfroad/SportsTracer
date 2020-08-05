//
//  SecuredNetworkService.swift
//  SportsTracer
//
//  Created by Li, Jin Hui on 2020/8/3.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

class SecuredNetworkService: NetwortService {
    
    // Designated to the GET Request with header fields
    func request(url request: URL, _ header: (key: String, value: String), _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: request)
        var HTTPHeaderFields = [header.key: header.value]
        HTTPHeaderFields["Content-Type"] = "application/json"
        
        request.allHTTPHeaderFields = HTTPHeaderFields
        
        super.request(request, completionHandler)
    }
    
    // Designated to the Request with header fields and POST body
    func request(url request: URL, _ header: (key: String, value: String), _ parameters: Dictionary<String, Any>, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: request)
        var HTTPHeaderFields = [header.key: header.value]
        HTTPHeaderFields["Content-Type"] = "application/json"
        
        request.allHTTPHeaderFields = HTTPHeaderFields
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = data
            request.httpMethod = "POST"
            
        } catch {
            print(error)
        }
        
        super.request(request, completionHandler)
    }
}
