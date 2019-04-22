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
            drinkLabel.text = drinkName
        }
    }
    
    func convert(index: Int, converter: (Int) -> String) -> String {
        return converter(index)
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction)->Void)?) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if NameTextField.text?.isEmpty == true {
            showAlert(title: "噢哦！", msg: "記得填上名字哦！", handler: nil)
            return
        }
        
        if let name = NameTextField.text, let drinkName = drinkName {
            
            let size = convert(index: sizeSegment.selectedSegmentIndex) { (index) -> String in
                if index == 0 {
                    return "M"
                } else {
                    return "L"
                }
            }
            
            let sweetness = convert(index: sweetSegment.selectedSegmentIndex) { (index) -> String in
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
            
            let ice = convert(index: iceSegment.selectedSegmentIndex) { (index) -> String in
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
            
            let order = Order(name: name, drink: drinkName, size: size, sweetness: sweetness, ice: ice, peral: pearl)
            
            OrderController.shared.postOrder(order: order) { (title, msg) in
                self.showAlert(title: title, msg: msg, handler: { (alert: UIAlertAction) in
                    self.refreshView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                })
            }
            refreshView = UIActivityIndicatorView(style: .whiteLarge)
            refreshView.color = .gray
            refreshView.center = self.tableView.center
            tableView.addSubview(refreshView)
            refreshView.startAnimating()
        }
    }
}
