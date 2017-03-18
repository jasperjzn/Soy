//
//  OrderStruct.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/16/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import Foundation
import UIKit

class OrderStruct{
    
    var counts = 0
    
    struct singleItem {
        var amount : Double
        var price : Double
    }
    
    var orderDict = [String : singleItem]()
    
    init(){
    }
    
    func getTotal() -> Double{
        var accumulate = 0.0
        for (_, val) in self.orderDict{
            accumulate += val.price * val.amount
        }
        return accumulate
    }
    
    
    func getValidItems() -> [String]{
        var templist = [String]()
        for (key, val) in self.orderDict{
            if(val.amount != 0.0){
                templist.append(key)
            }
        }
        return templist
    }
    
    func addItem(_ name: String, price: Double){
        let temp = singleItem(amount: 0.0, price: price)
        self.orderDict[name] = temp
        
    }
    
    func getAmountByName(_ name: String) -> Double{
        return (self.orderDict[name]?.amount)!
    }
    
    func getTotalByName(_ name: String) -> Double{
        return ((self.orderDict[name]?.amount)! * (self.orderDict[name]?.price)!)
    }
    
    func getCounts() -> Int{
        return self.counts
    }
    
    func reduceAmountByName(_ name: String){
        self.orderDict[name]?.amount = (self.orderDict[name]?.amount)! - 1.0
        self.counts = self.counts - 1
    }
    
    func addAmountByName(_ name: String){
        self.orderDict[name]?.amount = (self.orderDict[name]?.amount)! + 1.0
        self.counts = self.counts + 1
    }
}
