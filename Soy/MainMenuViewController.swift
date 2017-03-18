//
//  MainMenuViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/1/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


var hasCurrentOrder = 0
var hasPastOrder = 0
var tempImageG = UIImage()
var tempNameG = String()
var tempDescriptionG = String()
var tempPriceG = String()
var tempAmountG = String()

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var HelperView: UIView!
    @IBOutlet weak var comboUnderline: UIView!
    @IBOutlet weak var singleUnderline: UIView!
    @IBOutlet weak var CountsLabel: UILabel!
    @IBOutlet weak var TotalAmountDueLabel: UILabel!
    @IBOutlet weak var LocationsView: UITableView!
    @IBOutlet weak var ComboButton: UIButton!
    @IBOutlet weak var SingleButton: UIButton!
    @IBOutlet weak var CheckOutButton: UIButton!
    @IBOutlet weak var ItemsCollectionView: UICollectionView!
    @IBOutlet weak var LocationsTableViewBottomDistance: NSLayoutConstraint!
    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var CollectionviewBot: NSLayoutConstraint!
    
    var showingLocations = 0
    var inventoryDict = [String : String]()
    var outOfStockList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasCurrentOrder = 0
        hasPastOrder = 0
        
        
        reOrderMenuItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuViewController.dropCollectionView), name: NSNotification.Name(rawValue: "DropMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuViewController.liftCollectionView), name: NSNotification.Name(rawValue: "LiftMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuViewController.upgradeMenuAmounts), name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuViewController.upgradeTotalAmountDue), name: NSNotification.Name(rawValue: "UpgradeMainMenuTotalAmount"), object: nil)
        
        if(LocalOrder.getTotal() == 0.0){
            self.CollectionviewBot.constant = 0
        }
        else
        {
            self.CollectionviewBot.constant = 54
        }
        //----------------------------------------------------------------------------------------------------
        self.LocationButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 16)
        let LocationButtonTitle = NSMutableAttributedString(string: OrderLocation, attributes: [NSKernAttributeName: 0.8])
        LocationButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, LocationButtonTitle.length))
        self.LocationButton.setAttributedTitle(LocationButtonTitle, for: .normal)
        //----------------------------------------------------------------------------------------------------
        
        
        
        if (FIRAuth.auth()?.currentUser) != nil {
            databaseRef.child("Users").child(CU.getUid()).child("CurrentOrders").observe(.value, with: { (snapshot) in
                if(snapshot.hasChildren()){
                    let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 25))
                    profileButton.setImage(UIImage(named: "cut_profile_notification.png"), for: .normal)
                    profileButton.addTarget(self, action: #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
                }else{
                    let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 23))
                    profileButton.setImage(UIImage(named: "cut_profile.png"), for: .normal)
                    profileButton.addTarget(self, action: #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
                }
            }) { (error) in
            }
        }else{
            let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 23))
            profileButton.setImage(UIImage(named: "cut_profile.png"), for: .normal)
            profileButton.addTarget(self, action: #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        }
        
        
        
        self.LocationsView.alpha = 0
        self.LocationsTableViewBottomDistance.constant = self.view.frame.height - 64 - CGFloat(allLocations.count * 65)
        self.HelperView.alpha = 0
        self.HelperView.backgroundColor = UIColor.black
        
        
        SingleCombo = 0
        self.SingleButton.isEnabled = true
        self.ComboButton.isEnabled = false
        //----------------------------------------------------------------------------------------------------
        self.ComboButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.ComboButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let ComboButtonTitle = NSAttributedString(string: "COMBO", attributes: [NSKernAttributeName: 1.2])
        self.ComboButton.setAttributedTitle(ComboButtonTitle, for: .normal)
        //----------------------------------------------------------------------------------------------------
        self.SingleButton.tintColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.SingleButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 13)
        let SingleButtonTitle = NSAttributedString(string: "QUICK ITEMS", attributes: [NSKernAttributeName: 1.2])
        self.SingleButton.setAttributedTitle(SingleButtonTitle, for: .normal)
        //----------------------------------------------------------------------------------------------------
        self.CheckOutButton.tintColor = UIColor.white
        self.CheckOutButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 15)
        let CheckOutButtonTitle = NSAttributedString(string: "CHECK OUT", attributes: [NSKernAttributeName: 0.5])
        self.CheckOutButton.setAttributedTitle(CheckOutButtonTitle, for: .normal)
        self.CheckOutButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //----------------------------------------------------------------------------------------------------
        self.singleUnderline.backgroundColor = UIColor.white
        self.comboUnderline.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let TotalAmountDueLabelText = NSMutableAttributedString(
            string: "$" + String(LocalOrder.getTotal()),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 14)!])
        TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
        self.TotalAmountDueLabel.attributedText = TotalAmountDueLabelText
        self.TotalAmountDueLabel.textColor = UIColor.white
        self.TotalAmountDueLabel.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        
        
        //        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //
        //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        layout.itemSize = CGSize(width: screenSize.width - 26, height: ((screenSize.width-26)/349)*240+10)
        //        layout.footerReferenceSize = CGSize(width: screenSize.width - 26, height: 55)
        //        layout.minimumInteritemSpacing = 0
        //        layout.minimumLineSpacing = 0
        //        ItemsCollectionView!.collectionViewLayout = layout
        
        
        if(ReloadLocalOrder == 1){
            for item in MenuItems{
                LocalOrder.addItem(item.getName(), price: Double(item.getPrice())!)
            }
            for item in ComboItems{
                LocalOrder.addItem(item.getHashName(), price: Double(item.getPrice())!)
            }
        }
        
        self.CountsLabel.textColor = UIColor.white
        self.CountsLabel.text = String(LocalOrder.getCounts())
        self.CountsLabel.backgroundColor = UIColor.clear
        self.CountsLabel.layer.borderWidth = 1.5
        self.CountsLabel.layer.borderColor = UIColor.white.cgColor
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FIRAuth.auth()?.currentUser) != nil {
            databaseRef.child("Users").child(CU.getUid()).child("CurrentOrders").observe(.value, with: { (snapshot) in
                if(snapshot.hasChildren()){
                    hasCurrentOrder =  1
                    let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 25))
                    profileButton.setImage(UIImage(named: "cut_profile_notification.png"), for: .normal)
                    profileButton.addTarget(self, action: #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
                }else{
                    hasCurrentOrder = 0
                    let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 23))
                    profileButton.setImage(UIImage(named: "cut_profile.png"), for: .normal)
                    profileButton.addTarget(self, action:
                        #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
                }
            }) { (error) in
            }
            
            databaseRef.child("Users").child(CU.getUid()).child("PastOrders").observe(.value, with
                : { (snapshot) in
                    if(snapshot.hasChildren()){
                        hasPastOrder = 1
                    }else{
                        hasPastOrder = 0
                    }
            }) { (error) in
            }
        }else{
            let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 23))
            profileButton.setImage(UIImage(named: "cut_profile.png"), for: .normal)
            profileButton.addTarget(self, action: #selector(MainMenuViewController.ProfileTapped), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        }
    }
    
    func liftCollectionView(){
        self.CollectionviewBot.constant = 54
    }
    
    func dropCollectionView(){
        self.CollectionviewBot.constant = 0
    }
    
    
    func reOrderMenuItems()
    {
        var tempMenuItems = [ItemStruct]()
        for itemName in MenuItemNames{
            for item in MenuItems{
                if item.getName() == itemName{
                    tempMenuItems.append(item)
                }
            }
        }
        MenuItems = tempMenuItems
        
        
        var tempComboItems = [ComboItemStruct]()
        for itemName1 in ComboItemNames{
            for item in ComboItems{
                if item.getHashName() == itemName1{
                    tempComboItems.append(item)
                }
            }
        }
        ComboItems = tempComboItems
    }
    
    func upgradeMenuAmounts(
        ){
        self.ItemsCollectionView.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (SingleCombo == 0) {
            return ComboItems.count
        }
        else
        {
            return MenuItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width - 26, height: ((screenSize.width-26)/349)*240+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width - 26, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCellID", for: indexPath as IndexPath) as! ItemCell
        cell.ItemImage.layer.cornerRadius = 5
        cell.ItemImage.layer.masksToBounds = true
        if (SingleCombo == 0){
            cell.ItemImage.image = ComboItems[indexPath.section].getImage()
        }
        else
        {
            cell.ItemImage.image = MenuItems[indexPath.section].getImage()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ItemFooter", for: indexPath as IndexPath) as! ItemCollectionReusableView
        cell.NameLabel.textColor = UIColor.black
        
        
        cell.PriceLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        cell.AmountLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        cell.PlusButton.setImage(UIImage(named: "cut_plus_151.png"), for: UIControlState.normal)
        cell.PlusButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        cell.PlusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        cell.MinusButton.setImage(UIImage(named: "cut_minus_151.png"), for: UIControlState.normal)
        cell.MinusButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        cell.MinusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        let screenWidth = UIScreen.main.bounds.width
        cell.PlusButtonRight.constant = 11 * (screenWidth/375) * (screenWidth/375)
        cell.PlusButtonLeft.constant = 11 * (screenWidth/375) * (screenWidth/375)
        cell.AmountLabelLeft.constant = 11 * (screenWidth/375) * (screenWidth/375)
        
        if (SingleCombo == 0){
            let tempName = ComboItems[indexPath.section].getHashName()
            //-------------------------------------------------------------------------------------------------------
            let NameLabelText = NSMutableAttributedString(
                string: tempName,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Roman",
                    size: 15)!])
            NameLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, NameLabelText.length))
            cell.NameLabel.attributedText = NameLabelText
            cell.NameLabel.textColor = UIColor.black
            //-------------------------------------------------------------------------------------------------------
            let PriceLabelText = NSMutableAttributedString(
                string: "$ " + ComboItems[indexPath.section].getPrice() as String,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Roman",
                    size: 13)!])
            PriceLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, PriceLabelText.length))
            cell.PriceLabel.attributedText = PriceLabelText
            cell.PriceLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            //-------------------------------------------------------------------------------------------------------
            if(LocalOrder.getAmountByName(tempName) == 0.0){
                cell.AmountLabel.text = "0"
                cell.AmountLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            }
            else
            {
                cell.AmountLabel.text = String(Int(LocalOrder.getAmountByName(tempName)))
                cell.AmountLabel.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
            }
        }
        else
        {
            let tempName = MenuItems[indexPath.section].getName()
            //-------------------------------------------------------------------------------------------------------
            let NameLabelText = NSMutableAttributedString(
                string: tempName,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Roman",
                    size: 15)!])
            NameLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, NameLabelText.length))
            cell.NameLabel.attributedText = NameLabelText
            cell.NameLabel.textColor = UIColor.black
            
            
            //-------------------------------------------------------------------------------------------------------
            let PriceLabelText = NSMutableAttributedString(
                string: "$ " + MenuItems[indexPath.section].getPrice() as String,
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Roman",
                    size: 13)!])
            PriceLabelText.addAttribute(NSKernAttributeName, value: 1.2, range: NSMakeRange(0, PriceLabelText.length))
            cell.PriceLabel.attributedText = PriceLabelText
            cell.PriceLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            //-------------------------------------------------------------------------------------------------------
            if(LocalOrder.getAmountByName(tempName) == 0.0){
                cell.AmountLabel.text = "0"
                cell.AmountLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            }
            else
            {
                cell.AmountLabel.text = String(Int(LocalOrder.getAmountByName(tempName)))
                cell.AmountLabel.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
        let indexPaths = self.ItemsCollectionView!.indexPathsForSelectedItems!
        let indexPath = indexPaths[0] as NSIndexPath
        if (SingleCombo == 0){
            tempImageG = ComboItems[indexPath.section].getImage()
            let tempName = ComboItems[indexPath.section].getHashName()
            tempNameG = tempName
            tempPriceG = ComboItems[indexPath.section].getPrice()
            tempDescriptionG = ComboItems[indexPath.section].getDescription()
            tempAmountG = String(LocalOrder.getAmountByName(tempName))
        }
        else
        {
            tempImageG = MenuItems[indexPath.section].getImage()
            let tempName = MenuItems[indexPath.section].getName()
            tempNameG = tempName
            tempPriceG = MenuItems[indexPath.section].getPrice()
            tempDescriptionG = MenuItems[indexPath.section].getDescription()
            tempAmountG = String(LocalOrder.getAmountByName(tempName))
        }
    }
    
    
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "showImage"
    //        {
    //            let indexPaths = self.ItemsCollectionView!.indexPathsForSelectedItems()!
    //            let indexPath = indexPaths[0] as NSIndexPath
    //
    //            let vc = segue.destinationViewController as! BigPicViewController
    //            if (SingleCombo == 0){
    //                vc.img = ComboItems[indexPath.section].getImage()
    //                let tempName = ComboItems[indexPath.section].getHashName()
    //                vc.name = tempName
    //                vc.price = ComboItems[indexPath.section].getPrice()
    //                vc.descript = ComboItems[indexPath.section].getDescription()
    //                vc.currentShuliang = String(LocalOrder.getAmountByName(tempName))
    //            }
    //            else
    //            {
    //                vc.img = MenuItems[indexPath.section].getImage()
    //                let tempName = MenuItems[indexPath.section].getName()
    //                vc.name = tempName
    //                vc.price = MenuItems[indexPath.section].getPrice()
    //                vc.descript = MenuItems[indexPath.section].getDescription()
    //                vc.currentShuliang = String(LocalOrder.getAmountByName(tempName))
    //            }
    //        }
    //    }
    
    @IBAction func ComboTapped(_ sender: Any) {
        setCombo()
    }
    
    @IBAction func SingleTapped(_ sender: Any) {
        setSingle()
    }
    
    func setCombo(){
        SingleCombo = 0
        self.SingleButton.isEnabled = true
        self.ComboButton.isEnabled = false
        self.singleUnderline.backgroundColor = UIColor.white
        self.comboUnderline.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.SingleButton.tintColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.ComboButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
    }
    
    func setSingle(){
        SingleCombo = 1
        self.SingleButton.isEnabled = false
        self.ComboButton.isEnabled = true
        self.singleUnderline.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.comboUnderline.backgroundColor = UIColor.white
        self.ComboButton.tintColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.SingleButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
    }
    
    @IBAction func ShowLocations(_ sender: Any) {
        self.LocationsView.alpha = 1 - self.LocationsView.alpha
        if(self.showingLocations == 0){
            
            
            //----------------------------------------------------------------------------------------------------
            self.LocationButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 16)
            //            self.LocationButton.tintColor = UIColor.whiteColor()
            let LocationButtonTitle = NSMutableAttributedString(string: "Pick Up Location", attributes: [NSKernAttributeName: 0.8])
            LocationButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0, LocationButtonTitle.length))
            self.LocationButton.setAttributedTitle(LocationButtonTitle, for: .normal)
            //----------------------------------------------------------------------------------------------------
            self.showingLocations = 1
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.HelperView.alpha = 0.5
            self.SingleButton.isEnabled = false
            self.ComboButton.isEnabled = false
        }
        else
        {
            //----------------------------------------------------------------------------------------------------
            self.LocationButton.setTitleColor(UIColor.black, for: .normal)
            self.LocationButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 16)
            let LocationButtonTitle = NSMutableAttributedString(string: OrderLocation, attributes: [NSKernAttributeName: 0.8])
            LocationButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.black
                , range: NSMakeRange(0, LocationButtonTitle.length))
            self.LocationButton.setAttributedTitle(LocationButtonTitle, for: .normal)
            //----------------------------------------------------------------------------------------------------
            self.showingLocations = 0
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.HelperView.alpha = 0
            self.SingleButton.isEnabled = true
            self.ComboButton.isEnabled = true
        }
    }
    
    func upgradeTotalAmountDue(){
        let TotalAmountDueLabelText = NSMutableAttributedString(
            string: "$" + String(LocalOrder.getTotal()),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 14)!])
        TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
        self.TotalAmountDueLabel.attributedText = TotalAmountDueLabelText
        self.CountsLabel.text = String(LocalOrder.getCounts())
    }
    
    func refreshPage(){
        reOrderMenuItems()
        for item in MenuItems{
            LocalOrder.addItem(item.getName(), price: Double(item.getPrice())!)
        }
        for item in ComboItems{
            LocalOrder.addItem(item.getHashName(), price: Double(item.getPrice())!)
        }
        self.TotalAmountDueLabel.text = String(LocalOrder.getTotal())
        self.CountsLabel.text = String(LocalOrder.getCounts())
        self.LocationsView.reloadData()
        self.HelperView.alpha = 0
        self.showingLocations = 0
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil
            
        )
    }
    
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //----------------------------------------------------------------------------------------------------
        self.LocationButton.setTitleColor(UIColor.black, for: .normal)
        self.LocationButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 16)
        let LocationButtonTitle = NSMutableAttributedString(string: allLocations[indexPath.row], attributes: [NSKernAttributeName: 0.8])
        LocationButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.black
            , range: NSMakeRange(0, LocationButtonTitle.length))
        self.LocationButton.setAttributedTitle(LocationButtonTitle, for: .normal)
        //----------------------------------------------------------------------------------------------------
        if (allLocations[indexPath.row] != OrderLocation){
            OrderLocation = allLocations[indexPath.row]
            MenuItemNames = []
            MenuItems = [ItemStruct]()
            ComboItems = [ComboItemStruct]()
            ComboItemNames = []
            LocalOrder = OrderStruct()
            TotalDue = "0"
            setCombo()
            self.LocationsView.alpha = 0
            databaseRef.child("Items").child(OrderLocation).child("SingleItems").observe(.value, with: { (snapshot) in
                for eachItem in snapshot.children{
                    let itemName = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! String
                    MenuItemNames.append(itemName)
                    let itemDescription = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Description"] as! String
                    let itemPrice = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Price"] as! String
                    let itemImageName = ((eachItem as! FIRDataSnapshot).value! as! NSDictionary)["Image"] as! String
                    let ItemRef = storageRef.child("Items/" + itemImageName)
                    ItemRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for "images/island.jpg" is returned
                            let itemImage: UIImage! = UIImage(data: data!)
                            let tempItem : ItemStruct = ItemStruct(name: itemName, price: itemPrice, description: itemDescription, image: itemImage)
                            MenuItems.append(tempItem)
                        }
                    }
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            databaseRef.child("Items").child(OrderLocation).child(
                
                "Combos").observe(.value, with: { (snapshot) in
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
            
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.refreshPage), userInfo: nil, repeats: false)
            
        }
        else
        {
            self.LocationsView.alpha = 0
            self.showingLocations = 0
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.HelperView.alpha = 0
            self.SingleButton.isEnabled = true
            self.ComboButton.isEnabled = true
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LocationsView.dequeueReusableCell(withIdentifier: "LocationCell") as! ChangeLocationTableViewCell
        var LocationNameLabelTextColor = UIColor.white
        var LocationNameLabelText = ""
        var LocationAddressLabelTextColor = UIColor.white
        var LocationAddressLabelText = ""
        if (allLocations[indexPath.row] == OrderLocation){
            LocationNameLabelText = allLocations[indexPath.row]
            LocationNameLabelTextColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
            LocationAddressLabelText = allLocationsAddress[allLocations[indexPath.row]]!
            LocationAddressLabelTextColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        }
        else
        {
            LocationNameLabelText = allLocations[indexPath.row]
            LocationNameLabelTextColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
            LocationAddressLabelText = allLocationsAddress[allLocations[indexPath.row]]!
            LocationAddressLabelTextColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        }
        //-------------------------------------------------------------------------------------------------------
        let LocationNameLabelTText = NSMutableAttributedString(
            string: LocationNameLabelText,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 16)!])
        LocationNameLabelTText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LocationNameLabelTText.length))
        cell.LocationNameLabel.attributedText = LocationNameLabelTText
        cell.LocationNameLabel.textColor = LocationNameLabelTextColor
        //-------------------------------------------------------------------------------------------------------
        let LocationAddressLabelTText = NSMutableAttributedString(
            string: LocationAddressLabelText,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 12)!])
        LocationAddressLabelTText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LocationAddressLabelTText.length))
        cell.LocationAddressLabel.attributedText = LocationAddressLabelTText
        cell.LocationAddressLabel.textColor = LocationAddressLabelTextColor
        //-------------------------------------------------------------------------------------------------------
        
        return cell
    }
    
    func ProfileTapped(){
        if (FIRAuth.auth()?.currentUser) != nil {
            self.performSegue(withIdentifier: "MainToProfile", sender: self)
        } else {
            self.performSegue(withIdentifier: "MainToWelcome", sender: self)
        }
    }
    
    
    @IBAction func CheckOutDidTapped(_ sender: Any) {
        //databaseRef.child("Inventory").child(OrderLocation).observe(.value, with: { (snapshot) in
          //self.inventoryDict = [String : String]()
          //let tempDict = snapshot.value as! [String : String]
          //for item in LocalOrder.getValidItems(){
            //self.inventoryDict[item] = tempDict[item]
          //}
        //}) { (error) in
            //print(error.localizedDescription)
        //}
        //Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.processInventory), userInfo: nil, repeats: false)
    }
    
    func processInventory(){
        self.outOfStockList = [String]()
        for (key, val) in inventoryDict{
            
            if(LocalOrder.getAmountByName(key) > Double(val)!){
                outOfStockList.append(key)
            }
        }
        var outOfStockItems = ""
        for item in outOfStockList{
            outOfStockItems = outOfStockItems + " " + item
        }
        
        
        if (outOfStockList.count > 0){
            let alertController = UIAlertController(title: "Out of Stock", message: "\(outOfStockItems) are out of stock!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            let date = Date()
            let calendar = Calendar.current
            let oneDayfromNow = calendar.date(byAdding: .day, value: 1, to: Date())
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            formatter.timeZone = TimeZone(abbreviation: "PST")
            let currentHour = formatter.string(from: date)
            var pstDate : String
            var monday : String
            var day : String
            var month : String
            
            
            if Int(currentHour)! < Int(OfflineTime[1])!{
                formatter.dateFormat = "yyyy-MM-dd"
                pstDate = formatter.string(from: date)
                formatter.dateFormat = "EEEE"
                monday = formatter.string(from: date)
                formatter.dateFormat = "dd"
                day = formatter.string(from: date)
                formatter.dateFormat = "MMMM"
                month = formatter.string(from: date)
            }else{
                formatter.dateFormat = "yyyy-MM-dd"
                pstDate = formatter.string(from: oneDayfromNow!)
                formatter.dateFormat = "EEEE"
                monday = formatter.string(from: oneDayfromNow!)
                formatter.dateFormat = "dd"
                day = formatter.string(from: oneDayfromNow!)
                formatter.dateFormat = "MMMM"
                month = formatter.string(from: oneDayfromNow!)
            }
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let completeTime = formatter.string(from: date as Date)
            

            databaseRef.child("Users/\(CU.getUid())/Location").setValue(OrderLocation)
            
            var tempOrderDict = [String : String]()
            for item in LocalOrder.getValidItems(){
                tempOrderDict[item] = String(LocalOrder.getAmountByName(item))
                let newInventoryAmount = String(Double(self.inventoryDict[item]!)! - LocalOrder.getAmountByName(item))
                self.inventoryDict[item] = newInventoryAmount
                databaseRef.child("Inventory").child(OrderLocation).child(item).setValue(newInventoryAmount)
            }

            var tempOrderDict1 = [String : String]()
            tempOrderDict1["TotalAmount"] = String(LocalOrder.getTotal())
            databaseRef.child("Orders/\(pstDate)/\(OrderLocation)/\(CU.getUid())/\(completeTime)").setValue(tempOrderDict1)
            databaseRef.child("Orders/\(pstDate)/\(OrderLocation)/\(CU.getUid())/\(completeTime)/Items").setValue(tempOrderDict)
            
            tempOrderDict1["OrderLocation"] = OrderLocation
            tempOrderDict1["OrderLocationAddress"] = allLocationsAddress[OrderLocation]
            tempOrderDict1["Weekday"] = monday
            tempOrderDict1["Day"] = day
            tempOrderDict1["Month"] = month
            databaseRef.child("Users/\(CU.getUid())/CurrentOrders/\(completeTime)").setValue(tempOrderDict1)
            databaseRef.child("Users/\(CU.getUid())/CurrentOrders/\(completeTime)/Items").setValue(tempOrderDict)
//
        }
    }
    
}
