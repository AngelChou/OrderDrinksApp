//
//  ReportTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/22.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {

    @IBOutlet weak var refreshReportControl: UIRefreshControl!
    struct Report {
        var drink: String
        var count: Int
        var detail: [Order]
    }
    var reports = [Report]()
    var refreshView = UIActivityIndicatorView()
    var ordersCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshView = UIActivityIndicatorView(style: .whiteLarge)
        refreshView.color = .gray
        refreshView.center = self.tableView.center
        tableView.addSubview(refreshView)
        refreshView.startAnimating()
        
        OrderController.shared.getCount { (count) in
            if let count = count {
                self.ordersCount = count
            }
        }
        
        for drink in DrinkController.shared.drinks {
            OrderController.shared.search(drinkName: drink.name) { (orders) in
                if let orders = orders, orders.count != 0 {
                    self.reports.append(ReportTableViewController.Report(drink: drink.name, count: orders.count, detail: orders))
                    
                    DispatchQueue.main.async {
                        self.refreshView.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        refreshReportControl.addTarget(self, action: #selector(searchDrink), for: .valueChanged)
    }
    
    @objc func searchDrink() {
        OrderController.shared.getCount { (count) in
            if let count = count, count != self.ordersCount {
                self.ordersCount = count
                for drink in DrinkController.shared.drinks {
                    OrderController.shared.search(drinkName: drink.name) { (orders) in
                        if let orders = orders, orders.count != 0 {
                            self.reports.append(ReportTableViewController.Report(drink: drink.name, count: orders.count, detail: orders))
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.refreshReportControl.endRefreshing()
                }
                
            }
            else {
                DispatchQueue.main.async {
                    self.refreshReportControl.endRefreshing()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return reports.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCellId", for: indexPath)

        // Configure the cell...
        let report = reports[indexPath.section]
        let order = report.detail[indexPath.row]
        cell.textLabel?.text = "\(order.name): \(order.size)/\(order.ice)/\(order.sweetness)/\(order.peral)"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let report = reports[section]
        return "\(report.drink): \(report.count)杯"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
