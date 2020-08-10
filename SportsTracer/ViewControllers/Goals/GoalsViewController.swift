//
//  GoalsViewController.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/5.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit
import PKHUD

class GoalsViewController: UITableViewController {

    var goals = [Goal]()
    var healthRecords = [(name: String, type: Goal.Types, icon: String, value: Double, unit: String, lastTime: Date)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //https://developer.apple.com/documentation/healthkit/setting_up_healthkit
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull down to refresh your goals", comment: "Pull down to refresh your goals"))
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        HealthDataManager.shared.acquireHealthRecords { [weak self] (healthRecords) in
            
            self?.healthRecords = healthRecords
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        let items = DataManager.findGoals()
        
        if items.count == 0 {
            autoRefresh()
        } else {
            
            goals.removeAll()
            
            for item in items {
                let goal = item.toModel()
                goals.append(goal)
            }
            
            self.tableView.reloadData()
        }
    }
}

// Event handlers

extension GoalsViewController {
    
    func autoRefresh() {
        
        if let refreshControl = self.tableView.refreshControl {
            if !refreshControl.isRefreshing {
                refreshControl.autoBeginRefreshing(in: self.tableView)
            }
        }
    }
    
    @objc func handleRefresh(sender: UIRefreshControl) {
        
        if sender.isRefreshing {
            sender.attributedTitle = NSAttributedString(string: NSLocalizedString("Acquiring your goals", comment: "Acquiring your goals"))
            self.acquiredGoals(sender)
        }
    }
}

extension GoalsViewController {
    
    func acquiredCachedGoals() -> Void {
    }
    
    func acquiredGoals(_ refreshControl: UIRefreshControl? = nil) -> Void {
        
        let goalService = GoalService()
        
        goalService.acquireGoals("Jinhui") { [weak refreshControl, self] (result, goals, error) in
            
            if result {
                
                self.goals = goals
                
                for goal in goals {
                    let _ = DataManager.createGoal(goal)
                }
                
                self.tableView.reloadData()
                
            } else {
                HUD.flash(.labeledError(title: error?.localizedDescription, subtitle: nil), delay: 3.0)
            }
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
                refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull down to refresh your goals", comment: "Pull down to refresh your goals"))
            }
        }
    }
}

extension GoalsViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.goals.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let goalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCellIdentifier", for: indexPath) as? GoalTableViewCell {
            
            let goal = self.goals[indexPath.section]
            
            if let type = goal.type, let trophy = goal.reward?.trophy {
                
                var completion: Int64 = 0
                var lastTime = Date()
                
                for item in healthRecords {
                    
                    if item.type == type {
                        
                        completion = Int64(item.value)
                        lastTime = item.lastTime
                        
                        break
                    }
                }
                goalTableViewCell.configure(type, goal.title ?? "", goal.description ?? "", lastTime.toHourMinute(), completion, goal.value ?? 0, goal.reward?.points ?? 0, trophy)
            }
            
            return goalTableViewCell
            
        }

        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
