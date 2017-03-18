//
//  ProfileViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/17/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
//import SwiftQRCode
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

var UpComingOrders = [OrderDetailStruct]()
var PastOrders = [OrderDetailStruct]()

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var QRC: UIImageView!
    @IBOutlet weak var QRCTop: NSLayoutConstraint!
    @IBOutlet weak var QRCLeft: NSLayoutConstraint!
    @IBOutlet weak var QRCRight: NSLayoutConstraint!
    @IBOutlet weak var QRCBot: NSLayoutConstraint!
    @IBOutlet weak var ScrollContentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ViewAndEditButton: UIButton!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UpcomingOrderButton: UIButton!
    @IBOutlet weak var UpcomingLogo: UIImageView!
    @IBOutlet weak var pastOrderLogo: UILabel!
    @IBOutlet weak var PastOrdersButton: UIButton!
    @IBOutlet weak var ReportProblemButton: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpComingOrders = [OrderDetailStruct]()
        PastOrders = [OrderDetailStruct]()
        self.navigationItem.hidesBackButton = true
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        self.QRCLeft.constant = (screenWidth/375)*(screenWidth/375)*87
        self.QRCRight.constant = (screenWidth/375)*(screenWidth/375)*87
        self.QRCTop.constant = (screenHeight/667)*(screenHeight/667)*21
        self.QRCBot.constant = (screenHeight/667)*(screenHeight/667)*(screenHeight/667)*30
        self.ScrollContentViewHeight.constant = screenWidth*(321/375)+1+40+1+40+1+15+1+40+1+40+1+50+1+40+1+20
        //        self.QRC.image = NSCoder.generateImage(CU.getUid(), avatarImage: UIImage(named: "avatar"), avatarScale:0.3)
        self.QRC.image = self.generateQRC(Uid: CU.getUid())
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        BackButton.setImage(UIImage(named: "cut_close.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(ProfileViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        
        //-------------------------------------------------------------------------------------------------------
        let UserNameLabelText = NSMutableAttributedString(
            string: CU.getFirstName() + " " + CU.getLastName(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        UserNameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, UserNameLabelText.length))
        self.UserNameLabel.attributedText = UserNameLabelText
        self.UserNameLabel.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        self.ViewAndEditButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.ViewAndEditButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let ViewAndEditButtonTitle = NSAttributedString(string: "View and edit profile", attributes: [NSKernAttributeName: 0.8])
        self.ViewAndEditButton.setAttributedTitle(ViewAndEditButtonTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        self.UpcomingOrderButton.tintColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        self.UpcomingOrderButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let UpcomingOrderButtonTitle = NSAttributedString(string: "Upcoming Order", attributes: [NSKernAttributeName: 1])
        self.UpcomingOrderButton.setAttributedTitle(UpcomingOrderButtonTitle, for: .normal)
        self.UpcomingOrderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        //-------------------------------------------------------------------------------------------------------
        self.PastOrdersButton.tintColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        self.PastOrdersButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let PastOrdersButtonTitle = NSAttributedString(string: "Past Orders", attributes: [NSKernAttributeName: 1])
        self.PastOrdersButton.setAttributedTitle(PastOrdersButtonTitle, for: .normal)
        self.PastOrdersButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        //-------------------------------------------------------------------------------------------------------
        if(hasCurrentOrder == 1){
            self.UpcomingLogo.image = UIImage(named: "cut_upcoming.png")
            self.UpcomingOrderButton.isEnabled = true
            self.UpcomingOrderButton.alpha = 1
            
            databaseRef.child("Users").child(CU.getUid()).child("CurrentOrders").observe(.value, with: { (snapshot) in
                for eachItem in snapshot.children{
                    databaseRef.child("Users").child(CU.getUid()).child("CurrentOrders").child((eachItem as! FIRDataSnapshot).key).observe(.value, with: { (snapshot) in
                        let itemDict = (snapshot.value! as! NSDictionary)["Items"] as! [String : String]
                        let Day = (snapshot.value! as! NSDictionary)["Day"] as! String
                        let Weekday = (snapshot.value! as! NSDictionary)["Weekday"] as! String
                        let Month = (snapshot.value! as! NSDictionary)["Month"] as! String
                        let Location = (snapshot.value! as! NSDictionary)["OrderLocation"] as! String
                        let Address = (snapshot.value! as! NSDictionary)["OrderLocationAddress"] as! String
                        let TotalAmount = (snapshot.value! as! NSDictionary)["TotalAmount"] as! String
                        let tempOrderDetail = OrderDetailStruct()
                        tempOrderDetail.setDay(Day)
                        tempOrderDetail.setWeekday(Weekday)
                        tempOrderDetail.setMonth(Month)
                        tempOrderDetail.setLocation(Location)
                        tempOrderDetail.setAddress(Address)
                        tempOrderDetail.setTotalAmount(TotalAmount)
                        tempOrderDetail.setItems(itemDict)
                        UpComingOrders.append(tempOrderDetail)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else{
            self.UpcomingLogo.image = nil
            self.UpcomingOrderButton.isEnabled = false
            self.UpcomingOrderButton.alpha = 0.5
        }
        
        if(hasPastOrder == 1){
            self.pastOrderLogo.alpha = 1
            self.PastOrdersButton.isEnabled = true
            self.PastOrdersButton.alpha = 1
            
            databaseRef.child("Users").child(CU.getUid()).child("PastOrders").observe(.value, with: { (snapshot) in
                for eachItem in snapshot.children{
                    if(PastOrders.count < 10){
                        databaseRef.child("Users").child(CU.getUid()).child("PastOrders").child((eachItem as! FIRDataSnapshot).key).observe(.value, with: { (snapshot) in
                            let itemDict = (snapshot.value! as! NSDictionary)["Items"] as! [String : String]
                            let Day = (snapshot.value! as! NSDictionary)["Day"] as! String
                            let Weekday = (snapshot.value! as! NSDictionary)["Weekday"] as! String
                            let Month = (snapshot.value! as! NSDictionary)["Month"] as! String
                            let Location = (snapshot.value! as! NSDictionary)["OrderLocation"] as! String
                            let TotalAmount = (snapshot.value! as! NSDictionary)["TotalAmount"] as! String
                            let Address = (snapshot.value! as! NSDictionary)["OrderLocationAddress"] as! String
                            let tempOrderDetail = OrderDetailStruct()
                            tempOrderDetail.setDay(Day)
                            tempOrderDetail.setWeekday(Weekday)
                            tempOrderDetail.setMonth(Month)
                            tempOrderDetail.setLocation(Location)
                            tempOrderDetail.setAddress(Address)
                            tempOrderDetail.setTotalAmount(TotalAmount)
                            tempOrderDetail.setItems(itemDict)
                            PastOrders.append(tempOrderDetail)
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else{
            self.pastOrderLogo.alpha = 0
            self.PastOrdersButton.isEnabled = false
            self.PastOrdersButton.alpha = 0.5
        }
        self.ReportProblemButton.tintColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        self.ReportProblemButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let ReportProblemButtonTitle = NSAttributedString(string: "Report a Problem", attributes: [NSKernAttributeName: 1])
        self.ReportProblemButton.setAttributedTitle(ReportProblemButtonTitle, for: .normal)
        self.ReportProblemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        //-------------------------------------------------------------------------------------------------------
        self.LogoutButton.tintColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        self.LogoutButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let LogoutButtonTitle = NSAttributedString(string: "Sign Out", attributes: [NSKernAttributeName: 1])
        self.LogoutButton.setAttributedTitle(LogoutButtonTitle, for: .normal)
        self.LogoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        //-------------------------------------------------------------------------------------------------------
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //-------------------------------------------------------------------------------------------------------
        let UserNameLabelText = NSMutableAttributedString(
            string: CU.getFirstName() + " " + CU.getLastName(),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        UserNameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, UserNameLabelText.length))
        self.UserNameLabel.attributedText = UserNameLabelText
        self.UserNameLabel.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
    }
    
    @IBAction func LogOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        
        if(isOffline == 1){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let Offline = storyboard.instantiateViewController(withIdentifier: "OfflineVC")
            self.present(Offline, animated: true, completion: nil)
        }
        
        ReloadLocalOrder = 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
        CU = UserStruct()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MMVC = storyboard.instantiateViewController(withIdentifier: "NaviVC") as! UINavigationController
        self.present(MMVC, animated: true, completion: nil)
    }
    
    func generateQRC(Uid: String) -> UIImage?{
        let data = Uid.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 100, y: 100)
        let output = filter?.outputImage?.applying(transform)
        if output != nil{
            return UIImage(ciImage: output!)
        }
        return nil
    }
    
    func CancelDidTapped(){
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController!.popViewController(animated: true)
        
    }
}
