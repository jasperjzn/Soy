//
//  AutoLoadViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/12/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let databaseRef = FIRDatabase.database().reference()
let storageRef = FIRStorage.storage().reference()

var CU : UserStruct = UserStruct()
var MenuItems = [ItemStruct]()
var MenuItemNames : [String] = []
var ComboItems = [ComboItemStruct]()
var ComboItemNames : [String] = []
var LocalOrder = OrderStruct()
var TotalDue : String = "0"
var OrderLocation = String()
var allLocations = [String]()
var allLocationsAddress = [String : String]()
var SingleCombo = 0
var ReloadLocalOrder = 1
var OfflineTime : [String] = []
var isOffline = 0

class AutoLoadViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadOfflineTime()
    }
    
    func loadAll(){
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            var tempLocation = String()
            
            databaseRef.child("LocationAddress").observe(.value, with: { (snapshot) in
                allLocationsAddress = snapshot.value as! [String : String]
                for (eachLocation, _) in allLocationsAddress{
                    allLocations.append(eachLocation)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            databaseRef.child("Users").child(uid).observe(.value, with: { (snapshot) in
                // Get user value
                let email = (snapshot.value! as! NSDictionary)["EmailAddress"] as! String
                let phoneN = (snapshot.value! as! NSDictionary)["PhoneNumber"] as! String
                let location = (snapshot.value! as! NSDictionary)["Location"] as! String
                let firstName = (snapshot.value! as! NSDictionary)["FirstName"] as! String
                let lastName = (snapshot.value! as! NSDictionary)["LastName"] as! String
                let password = (snapshot.value! as! NSDictionary)["Password"] as! String
                tempLocation = location
                
                CU.setEmailAddress(email)
                CU.setPhoneNumber(phoneN)
                CU.setLocation(location)
                CU.setUid(uid)
                CU.setFirstName(firstName)
                CU.setLastName(lastName)
                CU.setPassword(password)
                
                OrderLocation = tempLocation
                
                
                databaseRef.child("Items").child(tempLocation).child("SingleItems").observe(.value, with: { (snapshot) in
                    for eachItem in snapshot.children{
                        let itemName = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! String
                        MenuItemNames.append(itemName)
                        let itemDescription = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Description"] as! String
                        let itemPrice = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Price"] as! String
                        let itemImageName = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Image"] as! String
                        let ItemRef = storageRef.child("Items/" + itemImageName)
                        ItemRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                            if (error == nil) {
                                let itemImage: UIImage! = UIImage(data: data!)
                                let tempItem : ItemStruct = ItemStruct(name: itemName, price: itemPrice, description: itemDescription, image: itemImage)
                                MenuItems.append(tempItem)
                            }
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
                databaseRef.child("Items").child(tempLocation).child("Combos").observe(.value, with: { (snapshot) in
                    for eachItem in snapshot.children{
                        let ItemNames = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! [String]
                        let ItemHashname = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Hashname"] as! String
                        ComboItemNames.append(ItemHashname)
                        let itemDescription = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Description"] as! String
                        let itemPrice = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Price"] as! String
                        let itemImageName = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Image"] as! String
                        let ItemRef = storageRef.child("Items/" + itemImageName)
                        ItemRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                            if (error == nil) {
                                let itemImage: UIImage! = UIImage(data: data!)
                                let tempItem : ComboItemStruct = ComboItemStruct(name: ItemNames, hashname: ItemHashname, price: itemPrice, description: itemDescription, image: itemImage)
                                ComboItems.append(tempItem)
                            }
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        } else {
            var location = String()
            var address = String()
            databaseRef.child("LocationAddress").observe(.value, with: { (snapshot) in
                for eachLocation in snapshot.children {
                    location = (eachLocation as! FIRDataSnapshot).key
                    allLocations.append(location)
                    address = (eachLocation as! FIRDataSnapshot).value! as! String
                    allLocationsAddress[location] = address
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let Picker = storyboard.instantiateViewController(withIdentifier: "PickLocationVC")
                self.present(Picker, animated: true, completion: nil)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    func loadOfflineTime() {
        databaseRef.child("OfflineTime").observe(.value, with: { (snapshot) in
            OfflineTime.append((snapshot.value! as! NSDictionary)["CloseHour"] as! String)
            OfflineTime.append((snapshot.value! as! NSDictionary)["ReopenHour"] as! String)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "PST") as TimeZone!
            let date = NSDate()
            let currentHour : String = dateFormatter.string(from: date as Date)
            if((Int(currentHour)! >= Int(OfflineTime[0] )!) && (Int(currentHour)! < Int(OfflineTime[1] )!)){
                
                isOffline = 1
                //                Timer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.timeToOffline), userInfo: nil, repeats: false)
            }
            else
            {
                self.loadAll()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    //
    //    func timeToOffline() {
    //        self.performSegueWithIdentifier("GoToOffline", sender: self)
    //    }
    
    func timeToMoveOn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MM = storyboard.instantiateViewController(withIdentifier: "NaviVC")
        self.present(MM, animated: true, completion: nil)
    }
}
