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
        OrderController.shared.fetchOrders { (orders) in
            if let orders = orders {
                self.orders = orders
                DispatchQueue.main.async {
                    self.refreshView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
        refreshView = UIActivityIndicatorView(style: .whiteLarge)
        refreshView.color = .gray
        refreshView.center = self.tableView.center
        tableView.addSubview(refreshView)
        refreshView.startAnimating()
        
        refreshOrderListControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    @objc func fetchData() {
        
        OrderController.shared.fetchOrders { (orders) in
            
            if let orders = orders {
                self.orders = orders
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshOrderListControl.endRefreshing()
                }
            }
        }
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
    
}
