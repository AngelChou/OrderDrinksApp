//
//  DrinksTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/16.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class DrinksTableViewController: UITableViewController {

    var drinks = [Drink]()
    var stores = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 讀取飲料清單
        DrinkController.shared.loadMenu(filename: "可不可熟成紅茶")
        self.drinks = DrinkController.shared.drinks
        DrinkController.shared.getStoreList { (stores) in
            if let stores = stores {
                self.stores = stores
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return drinks.count
        return stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCellId", for: indexPath)
//        let drink = drinks[indexPath.row]
//        cell.textLabel?.text = drink.name
//        cell.detailTextLabel?.text = drink.description
        cell.textLabel?.text = stores[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? DrinkDetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.drinkName = drinks[row].name
        }
    }
    
}
