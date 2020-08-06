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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //https://developer.apple.com/documentation/healthkit/setting_up_healthkit
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh your goals", comment: "Pull to refresh your goals"))
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        autoRefresh()
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
            sender.attributedTitle = NSAttributedString(string: NSLocalizedString("Synchronising your goals", comment: "Synchronising your goals"))
            self.acquiredGoals(sender)
        }
    }
}

extension GoalsViewController {
    
    func acquiredCachedGoals() -> Void {
    }
    
    func acquiredGoals(_ refreshControl: UIRefreshControl? = nil) -> Void {
        
        let goalService = GoalService()
        
        goalService.acquireGoals("Jinhui") { [weak refreshControl] (result, goals, error) in
            
            if result {
                
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: goals, requiringSecureCoding: true) {
                    
                    print(data)
                }
                
            } else {
                HUD.flash(.labeledError(title: error?.localizedDescription, subtitle: nil), delay: 3.0)
            }
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
                refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh your goals", comment: "Pull to refresh your goals"))
            }
        }
    }
}

extension GoalsViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
