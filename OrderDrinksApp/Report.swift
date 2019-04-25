//
//  Report.swift
//  OrderDrinksApp
//
//  Created by Shun-Ching, Chou on 2019/4/25.
//  Copyright © 2019 Shun-Ching, Chou. All rights reserved.
//

import Foundation

struct Report {
    var drink: String
    var count: Int
    var mediumCount: Int
    var largeCount: Int
    var price: Int
    var detail: [Order]
}

class ReportController {
    static let shared = ReportController()
    
    func createReport(drink: Drink, orders: [Order]) -> Report? {
        var report = Report(drink: drink.name, count: 0, mediumCount:0, largeCount: 0, price: 0, detail: [])
        for order in orders {
            if order.drink == report.drink {
                report.count = report.count + 1
                if order.size == "M" {
                    report.mediumCount  = report.mediumCount + 1
                } else {
                    report.largeCount = report.largeCount + 1
                }
                let pearl = order.peral == "加珍珠" ? 1 : 0
                report.price = report.mediumCount * drink.mediumPrice + report.largeCount * drink.largePrice + pearl * 10
                report.detail.append(order)
            }
        }
        if report.count != 0 {
            return report
        } else {
            return nil
        }
    }
    
    func getTotalPrice(reports: [Report]) -> (Int, Int) {
        var price = 0
        var count = 0
        for report in reports {
            price = price + report.price
            count = count + report.count
        }
        return (count, price)
    }
}
