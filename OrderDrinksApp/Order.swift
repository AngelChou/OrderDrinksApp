//
//  Order.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/16.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import Foundation
import UIKit

struct Order: Codable {
    var name: String
    var drink: String
    var size: String
    var sweetness: String
    var ice: String
    var peral: String
}

struct OrderData: Encodable {
    var data: Order
}

class OrderController {
    static let shared = OrderController()
    let sheetdbAPI = "https://sheetdb.io/api/v1/6iuokay610mvj"
    
    func fetchOrders(completion: @escaping ([Order]?) -> Void) {
        if let url = URL(string: self.sheetdbAPI) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let orders = try? decoder.decode([Order].self, from: data) {
                    completion(orders)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func postOrder(order: Order, completion: @escaping (String, String) -> Void) {
        let url = URL(string: self.sheetdbAPI)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let orderData = OrderData(data: order)
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(orderData) {
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error)in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["created"] == 1 {
                    completion("訂購成功", "謝謝")
                } else {
                    completion("訂購失敗", "請再試一次")
                }
            }
            task.resume()
        } else {
            completion("訂購失敗", "請再試一下")
        }
    }
    
}
