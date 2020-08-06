//
//  UIRefreshControl+AutoBeginRefresh.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/6.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

extension UIRefreshControl {

    func autoBeginRefreshing(in tableView: UITableView) {
        
        beginRefreshing()
        
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
        
        self.sendActions(for: .valueChanged)
    }
}
