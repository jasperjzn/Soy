//
//  LoginViewController.swift
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

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var ForgetPasswordButton: UIButton!
    @IBOutlet weak var LoginButtonBot: NSLayoutConstraint!
    @IBOutlet weak var InputViewTop: NSLayoutConstraint!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var allFilled = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Sign In", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(LoginViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        let EmailLabelText = NSMutableAttributedString(
            string: "Email",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        EmailLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailLabelText.length))
        self.EmailLabel.attributedText = EmailLabelText
        self.EmailLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let PasswordLabelText = NSMutableAttributedString(
            string: "Password",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        PasswordLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PasswordLabelText.length))
        self.PasswordLabel.attributedText = PasswordLabelText
        self.PasswordLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        //        let EmailText = NSMutableAttributedString(string: " ")
        //        EmailText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailText.length))
        //        self.Email.font = UIFont(name: "Avenir-Roman", size: 13)
        //        self.Email.attributedText = EmailText
        //        self.Email.textColor = UIColor.blackColor()
        //-------------------------------------------------------------------------------------------------------
        //        self.Password.textColor = UIColor.blackColor()
        //        self.Password.font = UIFont(name: "Avenir-Roman", size: 13)
        //-------------------------------------------------------------------------------------------------------
        
        self.ForgetPasswordButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.ForgetPasswordButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 12)
        let ForgetPasswordButtonAttributedTitle = NSAttributedString(string: "Forget Password?", attributes: [NSKernAttributeName: 0.8])
        self.ForgetPasswordButton.setAttributedTitle(ForgetPasswordButtonAttributedTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        self.InputView.layer.borderWidth = 1
        self.InputView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.InputView.layer.cornerRadius = 5
        self.InputView.layer.masksToBounds = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.InputViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
        
        UIApplication.shared.statusBarStyle = .default
        
        self.Email.addTarget(self, action: #selector(LoginViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.Password.addTarget(self, action: #selector(LoginViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.Password.addTarget(self, action: #selector(LoginViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        
        //-------------------------------------------------------------------------------------------------------
        self.LoginButton.tintColor = UIColor.white
        self.LoginButton.titleLabel!.font =  UIFont(name:"Avenir-Heavy", size: 14)
        self.LoginButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        let LoginButtonAttributedTitle = NSAttributedString(string: "Next", attributes: [NSKernAttributeName: 0.5])
        self.LoginButton.setAttributedTitle(LoginButtonAttributedTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.LoginButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.Email.becomeFirstResponder()
    }
    
    func TextFieldDidChange(_ textfield: UITextField){
        if(self.Password.text != "" && self.Email.text != ""){
            if (self.allFilled == 0){
                self.LoginButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
                self.allFilled = 1
                self.LoginButton.isEnabled = true
            }
        }
        else
        {
            self.LoginButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.allFilled = 0
            self.LoginButton.isEnabled = false
        }
        if(textfield == self.Email){
            let EmailText = NSMutableAttributedString(string: self.Email.text!)
            EmailText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailText.length))
            self.Email.font = UIFont(name: "Avenir-Roman", size: 13)
            self.Email.attributedText = EmailText
            self.Email.textColor = UIColor.black
        }
        if(textfield == self.Password)
        {
            let PasswordText = NSMutableAttributedString(string: self.Password.text!)
            PasswordText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PasswordText.length))
            self.Password.font = UIFont(name: "Avenir-Roman", size: 13)
            self.Password.attributedText = PasswordText
            self.Password.textColor = UIColor.black
        }
    }
    
    func EditBegin(_ textField: UITextField){
        if(textField == self.Password){
            self.LoginButton.isEnabled = false
            self.LoginButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.allFilled = 0
        }
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.LoginButtonBot.constant = keyboardHeight
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardHeight+53
        self.ScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.LoginButtonBot.constant = 0
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.ScrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.Email){
            self.Email.resignFirstResponder()
            self.Password.becomeFirstResponder()
            return true
        }
        else
        {
            self.Password.resignFirstResponder()
            if (self.LoginButton.isEnabled == true){
                self.loginHelper()
            }
            return true
        }
    }
    
    func CancelDidTapped(){
        view.endEditing(true)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 251/256, green: 152/256, blue: 102/256, alpha: 1)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func Login(_ sender: Any) {
        self.loginHelper()
    }
    
    func loginHelper(){
        if(isOffline == 1){
            FIRAuth.auth()?.signIn(withEmail: self.Email.text!, password: self.Password.text!, completion: {(user, error) in
                if error == nil{
                    
                    let uid = user!.uid
                    databaseRef.child("Users").child(uid).observe(.value, with: { (snapshot) in
                        
                        let email = (snapshot.value! as! NSDictionary)["EmailAddress"] as! String
                        let phoneN = (snapshot.value! as! NSDictionary)["PhoneNumber"] as! String
                        let location = (snapshot.value! as! NSDictionary)["Location"] as! String
                        let firstName = (snapshot.value! as!
                            NSDictionary)["FirstName"] as! String
                        let lastName = (snapshot.value! as! NSDictionary)["LastName"] as! String
                        let password = (snapshot.value! as! NSDictionary)["Password"] as! String
                        
                        CU.setFirstName(firstName)
                        CU.setLastName(lastName)
                        CU.setEmailAddress(email)
                        CU.setPhoneNumber(phoneN)
                        CU.setLocation(location)
                        CU.setUid(uid)
                        CU.setPassword(password)
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let Profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                        self.present(Profile, animated: true, completion: nil)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.Email.text!, password: self.Password.text!, completion: {(user, error) in
                if error == nil{
                    
                    let uid = user!.uid
                    var tempLocation = String()
                    databaseRef.child("Users").child(uid).observe(.value, with: { (snapshot) in
                        
                        
                        let email = (snapshot.value! as! NSDictionary)["EmailAddress"] as! String
                        let phoneN = (snapshot.value! as! NSDictionary)["PhoneNumber"] as! String
                        let location = (snapshot.value! as! NSDictionary)["Location"] as! String
                        let firstName = (snapshot.value! as! NSDictionary)["FirstName"] as! String
                        let lastName = (snapshot.value! as! NSDictionary)["LastName"] as! String
                        let password = (snapshot.value! as! NSDictionary)["Password"] as! String
                        
                        CU.setFirstName(firstName)
                        CU.setLastName(lastName)
                        tempLocation = location
                        CU.setEmailAddress(email)
                        CU.setPhoneNumber(phoneN)
                        CU.setLocation(location)
                        CU.setUid(uid)
                        CU.setPassword(password)
                        ReloadLocalOrder = 0
                        
                        if (location != OrderLocation){
                            
                            MenuItemNames = []
                            MenuItems = [ItemStruct]()
                            ComboItems = [ComboItemStruct]()
                            ComboItemNames = []
                            LocalOrder = OrderStruct()
                            TotalDue = "0"
                            SingleCombo = 0
                            OrderLocation = tempLocation
                            ReloadLocalOrder = 1
                            
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
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.LoginToMainMenu), userInfo: nil, repeats: false)
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    func LoginToMainMenu() {
        self.performSegue(withIdentifier: "LoginToMainMenu", sender: self)
    }
}
