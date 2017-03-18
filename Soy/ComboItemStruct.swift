//
//  ItemStruct.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/10/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import Foundation
import UIKit

class ComboItemStruct{
    
    var ItemName : [String]
    var ItemNameForHashTable : String
    var ItemPrice : String
    var ItemDescription : String
    var ItemImage : UIImage
    
    init(name : [String], hashname: String, price : String, description : String, image : UIImage){
        self.ItemName = name
        self.ItemNameForHashTable = hashname
        self.ItemPrice = price
        self.ItemDescription = description
        self.ItemImage = image
    }
    
    func getName() -> [String] {
        return self.ItemName
    }
    
    func getHashName() -> String {
        return self.ItemNameForHashTable
    }
    
    func getPrice() -> String {
        return self.ItemPrice
    }
    
    func getDescription() -> String {
        return self.ItemDescription
    }
    
    func getImage() -> UIImage {
        return self.ItemImage
    }
}
