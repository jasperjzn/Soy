//
//  OrderDetailStruct.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/24/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import Foundation
class OrderDetailStruct{
    
    var counts = 0
    var Day = String()
    var Weekday = String()
    var Month = String()
    var TotalAmount = String()
    var Address = String()
    var Location = String()
    var Items = [String: String]()
    var ItemNames = [String()]
    
    init(){
        self.ItemNames = []
    }
    
    func setDay(_ input : String) {
        self.Day = input
    }
    
    func setWeekday(_ input : String) {
        self.Weekday = input
    }
    
    func setMonth(_ input : String) {
        self.Month = input
    }
    
    func setLocation(_ input : String) {
        self.Location = input
    }
    
    func setAddress(_ input : String) {
        self.Address = input
    }
    
    func setTotalAmount(_ input : String) {
        self.TotalAmount = input
    }
    
    func setItems(_ input : [String : String]) {
        self.Items = input
        for (key, _)in input{
            self.ItemNames.append(key)
        }
    }
    
    func getDay() -> String {
        return self.Day
    }
    
    func getWeekday() -> String {
        return self.Weekday
    }
    
    func getMonth() -> String {
        return self.Month
    }
    
    func getTotalAmount() -> String {
        return self.TotalAmount
    }
    
    func getLocation() -> String {
        return self.Location
    }
    
    func getAddress() -> String {
        return self.Address
    }
    
    func getItems() -> [String : String] {
        return self.Items
    }
    
    func getItemNames() -> [String] {
        return self.ItemNames
    }
}
