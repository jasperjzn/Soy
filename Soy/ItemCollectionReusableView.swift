//
//  ItemCollectionReusableView.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/18/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit

class ItemCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var PlusButton: UIButton!
    @IBOutlet weak var MinusButton: UIButton!
    @IBOutlet weak var PlusButtonRight: NSLayoutConstraint!
    @IBOutlet weak var AmountLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var PlusButtonLeft: NSLayoutConstraint!
    @IBAction func AddOne(_ sender: Any) {
        if(self.AmountLabel.text == "0"){
            self.AmountLabel.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        }
        if(LocalOrder.getTotal() == 0.0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LiftMenu"), object: nil
            )
        }
        self.AmountLabel.text = String(Int(self.AmountLabel.text!)! + 1)
        LocalOrder.addAmountByName(self.NameLabel.text!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMainMenuTotalAmount"), object: nil
        )
    }
    @IBAction func MinusOne(_ sender: Any) {
        if(self.AmountLabel.text == "1"){
            self.AmountLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        }
        if(Int(self.AmountLabel.text!)! >= 1){
            self.AmountLabel.text = String(Int(self.AmountLabel.text!)! - 1)
            LocalOrder.reduceAmountByName(self.NameLabel.text!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMainMenuTotalAmount"), object: nil)
            if(LocalOrder.getTotal() == 0.0){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DropMenu"), object: nil
                )
            }
        }
    }
}
