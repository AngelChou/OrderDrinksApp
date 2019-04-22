//
//  DrinksTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/16.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class DrinksTableViewController: UITableViewController {

    var drinkNames = [String]()
    var drinkDescriptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 讀取飲料清單
        if let asset = NSDataAsset(name: "可不可熟成紅茶"), let content = String(data: asset.data, encoding: .utf8) {
            let drinks = content.components(separatedBy: "\n")
            for drink in drinks {
                let array = drink.components(separatedBy: ",")
                drinkNames.append(array[0])
                drinkDescriptions.append(array[1])
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinkNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCellId", for: indexPath)

        // Configure the cell...
        let row = indexPath.row
        cell.textLabel?.text = drinkNames[row]
        cell.detailTextLabel?.text = drinkDescriptions[row]

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? DrinkDetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.drinkName = drinkNames[row]
        } 
    }
    
}
