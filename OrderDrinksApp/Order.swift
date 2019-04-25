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
    var orders = [Order]()
    
    // Get - All Data
    func getAllData(completion: @escaping ([Order]?) -> Void) {
        if let url = URL(string: self.sheetdbAPI) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let orders = try? decoder.decode([Order].self, from: data) {
                    self.orders = orders
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
    
    // POST - Create row
    func post(order: Order, completion: @escaping (String, String?) -> Void) {
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
                    completion("新增成功", nil)
                } else {
                    completion("新增失敗", "請重新訂購")
                }
            }
            task.resume()
        } else {
            completion("新增失敗", "請重新訂購")
        }
    }
    
    // DELETE
    func delete(order: Order, completion: @escaping (String) -> Void) {
        if let urlStr = "\(self.sheetdbAPI)/name/\(order.name)/".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let orderData = OrderData(data: order)
            let jsonEncoder = JSONEncoder()
            if let data = try? jsonEncoder.encode(orderData) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error)in
                    let decoder = JSONDecoder()
                    if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["deleted"] == 1 {
                        completion("刪除成功")
                    } else {
                        completion("刪除失敗")
                    }
                }
                task.resume()
            } else {
                completion("刪除失敗")
            }
        }
    }
    
    func update(order: Order, completion: @escaping (String) -> Void) {
        if let urlStr = "\(self.sheetdbAPI)/name/\(order.name)/".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let orderData = OrderData(data: order)
            let jsonEncoder = JSONEncoder()
            if let data = try? jsonEncoder.encode(orderData) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error)in
                    let decoder = JSONDecoder()
                    if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["updated"] == 1 {
                        completion("修改成功")
                    } else {
                        completion("修改失敗")
                    }
                }
                task.resume()
            } else {
                completion("修改失敗")
            }
        }
    }
    
    // GET - Search in document
    func search(drinkName: String, completion: @escaping ([Order]?) -> Void) {
        if let urlStr = "\(self.sheetdbAPI)/search?drink=\(drinkName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
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
    
    // GET - Count
    func getCount(completion: @escaping (Int?) -> Void) {
        if let url = URL(string: "\(self.sheetdbAPI)/count") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let result = try? decoder.decode([String:Int].self, from: data) {
                    completion(result["rows"])
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    
}
