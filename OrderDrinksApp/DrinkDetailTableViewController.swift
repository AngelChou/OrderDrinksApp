//
//  DrinkDetailTableViewController.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/16.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import UIKit

class DrinkDetailTableViewController: UITableViewController {
    
    var drinkName: String?
    var order: Order?
    var refreshView = UIActivityIndicatorView()
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var sweetSegment: UISegmentedControl!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    @IBOutlet weak var pearlSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let drinkName = drinkName {
            // 若是從飲料Menu過來，會得到飲料名稱
            drinkLabel.text = drinkName
        } else if let order = order {
            //若是從訂購明細過來，會得到一筆訂單資料
            NameTextField.text = order.name
            drinkLabel.text = order.drink
            sizeSegment.selectedSegmentIndex = convertStringToIndex(str: order.size)
            sweetSegment.selectedSegmentIndex = convertStringToIndex(str: order.sweetness)
            iceSegment.selectedSegmentIndex = convertStringToIndex(str: order.ice)
            pearlSwitch.isOn = order.peral == "加珍珠" ? true : false
        }
        
        // 設定Act ivityIndicator
        refreshView = UIActivityIndicatorView(style: .whiteLarge)
        refreshView.color = .gray
        refreshView.center = self.tableView.center
        tableView.addSubview(refreshView)
    }
    
    func convertStringToIndex(str: String) -> Int {
        switch str {
        case "M", "正常":
            return 0
        case "L", "少糖", "少冰":
            return 1
        case "半糖", "微冰":
            return 2
        case "微糖", "去冰":
            return 3
        case "無糖", "熱飲":
            return 4
        default:
            return 0
        }
    }
    
    func convertIndexToString(index: Int, converter: (Int) -> String) -> String {
        return converter(index)
    }
    
    func orderComplete(title: String, msg: String?) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.refreshView.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        // 檢查
        if NameTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "記得填上名字哦！", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        // 收起鍵盤
        self.view.endEditing(true)
        
        // 從UI元件取得訂單資料
        if let name = NameTextField.text, let drinkName = drinkLabel.text {
            
            let size = convertIndexToString(index: sizeSegment.selectedSegmentIndex) { (index) -> String in
                if index == 0 {
                    return "M"
                } else {
                    return "L"
                }
            }
            
            let sweetness = convertIndexToString(index: sweetSegment.selectedSegmentIndex) { (index) -> String in
                switch(index) {
                case 1:
                    return "少糖"
                case 2:
                    return "半糖"
                case 3:
                    return "微糖"
                case 4:
                    return "無糖"
                default:
                    return "正常"
                }
            }
            
            let ice = convertIndexToString(index: iceSegment.selectedSegmentIndex) { (index) -> String in
                switch(index) {
                case 1:
                    return "少冰"
                case 2:
                    return "微冰"
                case 3:
                    return "去冰"
                case 4:
                    return "熱飲"
                default:
                    return "正常"
                }
            }
            
            let pearl = pearlSwitch.isOn ? "加珍珠" : "不加珍珠"
            
            // 建立一筆訂單
            let newOrder = Order(name: name, drink: drinkName, size: size, sweetness: sweetness, ice: ice, peral: pearl)
            
            if let _ = self.drinkName {
                // 新增訂單
                OrderController.shared.post(order: newOrder) { (title, msg) in
                    self.orderComplete(title: title, msg: msg)
                }
            } else if let _ = self.order {
                // 修改訂單
                OrderController.shared.update(order: newOrder) { (title) in
                    self.orderComplete(title: title, msg: nil)
                }
            }
            
            // 顯示ActivityIndicator
            refreshView.startAnimating()
        }
    }
}
