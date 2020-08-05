//
//  NetwortService.swift
//  SportsTracer
//
//  Created by Li, Jin Hui on 2020/8/3.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

class NetwortService: NSObject, URLSessionDataDelegate {

    static let ErrorDomain = "NetworkService"
    static let DefaultCode = 1000
    
    private lazy var urlSession: URLSession = {
        
        let config = URLSessionConfiguration.ephemeral
        
        config.waitsForConnectivity = false
        config.shouldUseExtendedBackgroundIdleMode = true
        
        return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    func request(_ request: URLRequest, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let dataTask = self.urlSession.dataTask(with: request, completionHandler: completionHandler)
        
        dataTask.resume()
    }
    
    func uploadRequest(request: URLRequest, fromFile: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let uploadTask = self.urlSession.uploadTask(with: request, fromFile: fromFile, completionHandler: completionHandler)
        
        uploadTask.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        SSLPinning.shared.handleChallenge(session, challenge, completionHandler)
    }
}
