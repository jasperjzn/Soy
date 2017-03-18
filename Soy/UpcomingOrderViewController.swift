//
//  UpcomingOrderViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/23/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit

class UpcomingOrderViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var OrdersCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.CollectionViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Upcoming Orders", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(UpcomingOrderViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UpComingOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let tempHeight = 12+12+(UpComingOrders[indexPath.row].getItems().count)*34+1+68+1+136
        return CGSize(width: screenSize.width - 34, height: CGFloat(tempHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 17, bottom: 25, right: 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OrdersCollectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingOrdersCell", for: indexPath as IndexPath) as! OrderCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        cell.OrderItemsTableView.dataSource = cell
        cell.OrderItemsTableViewHeight.constant = CGFloat(UpComingOrders[indexPath.row].getItems().count*34)
        cell.Orders = UpComingOrders[indexPath.row].getItems()
        cell.OrderNames = UpComingOrders[indexPath.row].getItemNames()
        //-------------------------------------------------------------------------------------------------------
        let TotalAmountLabelText = NSMutableAttributedString(
            string: "US$"+UpComingOrders[indexPath.row].getTotalAmount(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        TotalAmountLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, TotalAmountLabelText.length))
        cell.TotalAmountLabel.attributedText = TotalAmountLabelText
        cell.TotalAmountLabel.textColor = UIColor.black
        cell.TotalAmountLabel.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        cell.LocationMarkerImage.image = UIImage(named: "cut_map_marker_coral.png")
        //-------------------------------------------------------------------------------------------------------
        let LocationNameLabelText = NSMutableAttributedString(
            string: UpComingOrders[indexPath.row].getLocation(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        LocationNameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LocationNameLabelText.length))
        cell.LocationNameLabel.attributedText = LocationNameLabelText
        cell.LocationNameLabel.textColor = UIColor.black
        cell.LocationNameLabel.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        let LocationAddressLabelText = NSMutableAttributedString(
            string: UpComingOrders[indexPath.row].getAddress(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        LocationAddressLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, LocationAddressLabelText.length))
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 10
        //        LocationAddressLabelText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, LocationAddressLabelText.length))
        cell.LocationAddressLabel.attributedText = LocationAddressLabelText
        cell.LocationAddressLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        cell.LocationAddressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.LocationAddressLabel.numberOfLines = 0
        cell.LocationAddressLabel.sizeToFit()
        cell.LocationAddressLabel.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        cell.ClockImage.image = UIImage(named: "cut_clock_coral.png")
        //-------------------------------------------------------------------------------------------------------
        let PickUpTimeLabelText = NSMutableAttributedString(
            string: "7:30-11 AM",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        PickUpTimeLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PickUpTimeLabelText.length))
        cell.PickUpTime.attributedText = PickUpTimeLabelText
        cell.PickUpTime.textColor = UIColor.black
        cell.PickUpTime.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        let PickUpWeekdayLabelText = NSMutableAttributedString(
            string: UpComingOrders[indexPath.row].getWeekday(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        PickUpWeekdayLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, PickUpWeekdayLabelText.length))
        cell.PickUpWeekday.attributedText = PickUpWeekdayLabelText
        cell.PickUpWeekday.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        cell.PickUpWeekday.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        let PickUpDayLabelText = NSMutableAttributedString(
            string: UpComingOrders[indexPath.row].getMonth() + " " + UpComingOrders[indexPath.row].getDay(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        PickUpDayLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, PickUpDayLabelText.length))
        cell.PickUpDay.attributedText = PickUpDayLabelText
        cell.PickUpDay.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        cell.PickUpDay.textAlignment = .center
        //-------------------------------------------------------------------------------------------------------
        return cell
    }
    
    func CancelDidTapped(){
        self.navigationController!.popViewController(animated: true)
    }
    
    
}
