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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 讀取飲料清單
        DrinkController.shared.loadMenu(filename: "可不可熟成紅茶")
        self.drinks = DrinkController.shared.drinks
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCellId", for: indexPath)
        // 顯示飲料名稱
        let drink = drinks[indexPath.row]
        cell.textLabel?.text = drink.name
        cell.detailTextLabel?.text = drink.description
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? DrinkDetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            // 傳送選到的飲料名稱
            controller.drinkName = drinks[row].name
            
        }
    }
    
}
