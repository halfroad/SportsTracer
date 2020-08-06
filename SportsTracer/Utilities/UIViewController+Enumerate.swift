//
//  UIViewController+Enumerate.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/6.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    // Executes the provided closure on the current view controller
    // and on all of its descendants in the view controller hierarchy.
    func enumerateHierarchy(_ closure: (UIViewController) -> Void) {
        closure(self)
        
        for child in children {
            child.enumerateHierarchy(closure)
        }
    }
}
