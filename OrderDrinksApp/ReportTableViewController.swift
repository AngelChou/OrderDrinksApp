//
//  ReportTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/22.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {

    @IBOutlet weak var reportNavItem: UINavigationItem!
    @IBOutlet weak var refreshReportControl: UIRefreshControl!
    
    var reports = [Report]()
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得Local訂單資料
        self.orders = OrderController.shared.orders

        // 設定refreshControl
        refreshReportControl.addTarget(self, action: #selector(checkNewOrders), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 檢查是否有新訂單
        checkNewOrders()
    }
    
    @objc func checkNewOrders() {
        // 如果Local訂單數和Remote訂單數不同，則重新下載訂單
        OrderController.shared.getCount { (count) in
            if let count = count, count != self.orders.count {
                OrderController.shared.getAllData { (orders) in
                    if let orders = orders {
                        // 更新Local訂單
                        self.orders = orders
                        OrderController.shared.orders = orders
                        
                        // 使用更新的訂單建立報表
                        self.getReports()
                    }
                }
            } else {
                // 使用現存的訂單建立報表
                self.getReports()
            }
        }
    }
    
    func getReports() {
        // 產生報表
        for drink in DrinkController.shared.drinks {
            if let report = ReportController.shared.createReport(drink: drink, orders: orders) {
                self.reports.append(report)
            }
        }
        // 結算杯數和總價
        let (count, price) = ReportController.shared.getTotalPrice(reports: self.reports)
        self.navigationItem.title = "訂購總數：\(count)杯, 共\(price)元"
        
        self.refreshReportControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let report = reports[section]
        return "\(report.drink): \(report.mediumCount)杯M, \(report.largeCount)杯L（\(report.price)元）"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
        let order = reports[indexPath.section].detail[indexPath.row]
        cell.textLabel?.text = "\(order.name): \(order.size)/\(order.ice)/\(order.sweetness)/\(order.peral)"
        return cell
    }
 
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let controller = UIAlertController(title: "店家資訊", message: "可不可熟成紅茶 - 臺北伊通店", preferredStyle: .actionSheet)
        let phoneNumber = "0225175510"
        let phoneAction = UIAlertAction(title: "打電話給 \(phoneNumber)", style: .default) { (_) in
            if let url = URL(string: "tel:\(phoneNumber)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("無法開啓URL")
                }
            } else {
                print("連結錯誤")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(phoneAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}
