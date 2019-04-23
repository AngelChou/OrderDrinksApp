//
//  OrderListTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/16.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    @IBOutlet weak var refreshOrderListControl: UIRefreshControl!
    var orders = [Order]()
    var refreshView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下載訂單
        fetchData()
        
        // 設定refreshControl
        refreshOrderListControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        // 設定ActivityIndicator
        refreshView = UIActivityIndicatorView(style: .whiteLarge)
        refreshView.color = .gray
        refreshView.center = self.tableView.center
        tableView.addSubview(refreshView)
        
        // 啓動ActivityIndicator
        refreshView.startAnimating()
    }
    
    @objc func fetchData() {
        OrderController.shared.getAllData { (orders) in
            if let orders = orders {
                self.orders = orders
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshView.stopAnimating()
                    self.refreshOrderListControl.endRefreshing()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCellId", for: indexPath)

        // Configure the cell...
        let order = orders[indexPath.row]
        cell.textLabel?.text = "\(order.name): \(order.drink)(\(order.size)/\(order.ice)/\(order.sweetness)/\(order.peral))"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        // 顯示確認視窗
        let controller = UIAlertController(title: "\(order.name):\(order.drink)", message: "確定要刪除這筆訂單嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            OrderController.shared.delete(order: order) { (msg) in
                print("\(order.name):\(order.drink) \(msg)")
            }
            self.orders.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cacenl", style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DrinkDetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.order = orders[row]
        }
    }
}
