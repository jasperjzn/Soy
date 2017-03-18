//
//  PickLocationViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/17/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage


class PickLocationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var ChooseTop: NSLayoutConstraint!
    @IBOutlet weak var LocationsTop: NSLayoutConstraint!
    
    @IBOutlet weak var LocationsCollectionView: UICollectionView!
    var pickedLocation = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickedLocation = allLocations[0]
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.ChooseTop.constant = (screenSize.height/667)*(screenSize.height/667)*104
        self.LocationsTop.constant = (screenSize.height/667)*(screenSize.height/667)*42
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenSize.width-60 , height: 86)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        LocationsCollectionView!.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allLocations.count
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickLocationCell", for: indexPath as IndexPath) as! PickLocationCollectionViewCell
        let tempLocation = allLocations[indexPath.row]
        let LocationNameLabelText = NSMutableAttributedString(
            string: tempLocation,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 16)!])
        LocationNameLabelText.addAttribute(NSKernAttributeName, value: 1.1, range: NSMakeRange(0, LocationNameLabelText.length))
        cell.LocationNameLabel.attributedText = LocationNameLabelText
        cell.LocationNameLabel.textColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        
        
        let LocationAddrLabelText = NSMutableAttributedString(
            string: allLocationsAddress[tempLocation]!,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 12)!])
        LocationAddrLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, LocationAddrLabelText.length))
        cell.LocationAddrLabel.attributedText = LocationAddrLabelText
        cell.LocationAddrLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        
        cell.contentView.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pickedLocation = allLocations[indexPath.row]
        let cell = LocationsCollectionView.cellForItem(at: indexPath as IndexPath) as! PickLocationCollectionViewCell
        cell.LocationAddrLabel.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        cell.LocationNameLabel.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.LocationChosen()
        
    }
    
    func LocationChosen() {
        
        databaseRef.child("Items").child(self.pickedLocation).child("SingleItems").observe(.value, with: { (snapshot) in
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
        
        
        databaseRef.child("Items").child(self.pickedLocation).child("Combos").observe(.value, with: { (snapshot) in
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
        
        OrderLocation = self.pickedLocation
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GoToMainMenu), userInfo: nil, repeats: false)
    }
    
    
    
    
    
    func GoToMainMenu() {
        self.performSegue(withIdentifier: "PickerToMainMenu", sender: self)
    }
    
}
