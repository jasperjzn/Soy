//
//  OrderCollectionViewCell.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/24/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell, UITableViewDataSource {
    
    
    @IBOutlet weak var OrderItemsTableView: UITableView!
    @IBOutlet weak var OrderItemsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TotalAmountLabel: UILabel!
    @IBOutlet weak var LocationMarkerImage: UIImageView!
    @IBOutlet weak var LocationNameLabel: UILabel!
    @IBOutlet weak var LocationAddressLabel: UILabel!
    @IBOutlet weak var ClockImage: UIImageView!
    @IBOutlet weak var PickUpTime: UILabel!
    @IBOutlet weak var PickUpWeekday: UILabel!
    @IBOutlet weak var PickUpDay: UILabel!
    
    var Orders = [String : String]()
    var OrderNames = [String()]
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OrderNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderItemsTableView.dequeueReusableCell(withIdentifier: "ItemAmountCell")
        let Amount = cell?.viewWithTag(1) as! UILabel
        let Name = cell?.viewWithTag(2) as! UILabel
        let indexName = self.OrderNames[indexPath.row]
        Amount.text = String(Int(Double(self.Orders[indexName]!)!))
        Amount.font = UIFont(name: "Avenir-Heavy", size: 13)
        Amount.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let NameLabelText = NSMutableAttributedString(
            string: indexName,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        NameLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, NameLabelText.length))
        Name.attributedText = NameLabelText
        Name.textColor = UIColor.black
        
        
        
        return cell!
    }
}
