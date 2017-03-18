//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    
    @IBOutlet weak var ByContinueLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    
    @IBOutlet weak var NextButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var InputViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var ByContinutingLeft: NSLayoutConstraint!
    @IBOutlet weak var TermsOfServiceRight: NSLayoutConstraint!
    
    var allFilled = 0
    var currentEditing = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Sign Up", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(SignUpViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        let FirstNameLabelText = NSMutableAttributedString(
            string: "First Name",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        FirstNameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, FirstNameLabelText.length))
        self.FirstNameLabel.attributedText = FirstNameLabelText
        self.FirstNameLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let LastNameLabelText = NSMutableAttributedString(
            string: "Last Name",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        LastNameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LastNameLabelText.length))
        self.LastNameLabel.attributedText = LastNameLabelText
        self.LastNameLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
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
        let PhoneNumberLabelText = NSMutableAttributedString(
            string: "Phone Number",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        PhoneNumberLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PhoneNumberLabelText.length))
        self.PhoneNumberLabel.attributedText = PhoneNumberLabelText
        self.PhoneNumberLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let ByContinueLabelText = NSMutableAttributedString(
            string: "By continuing, I agree to Soy’s",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 12)!])
        ByContinueLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, ByContinueLabelText.length))
        self.ByContinueLabel.attributedText = ByContinueLabelText
        self.ByContinueLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        self.termsButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 0.8)
        self.termsButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 12)
        let termsButtonTitle = NSAttributedString(string: "terms of service", attributes: [NSKernAttributeName: 0.8])
        self.termsButton.setAttributedTitle(termsButtonTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.ScrollViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*0
        self.InputViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
        self.ByContinutingLeft.constant = (screenSize.width - 291)/2
        self.TermsOfServiceRight.constant = (screenSize.width - 291)/2
        self.InputView.layer.borderWidth = 1
        self.InputView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.InputView.layer.cornerRadius = 5
        self.InputView.layer.masksToBounds = true
        
        UIApplication.shared.statusBarStyle = .default
        
        self.Email.addTarget(self, action: #selector(SignUpViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.Password.addTarget(self, action: #selector(SignUpViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.FirstName.addTarget(self, action: #selector(SignUpViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.LastName.addTarget(self, action: #selector(SignUpViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.PhoneNumber.addTarget(self, action: #selector(SignUpViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.Email.addTarget(self, action: #selector(SignUpViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.Password.addTarget(self, action: #selector(SignUpViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.FirstName.addTarget(self, action: #selector(SignUpViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.LastName.addTarget(self, action: #selector(SignUpViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.PhoneNumber.addTarget(self, action: #selector(SignUpViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide
            ), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.SignUpButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.SignUpButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (currentEditing == "Email"){
            self.Email.becomeFirstResponder()
        }
        if (currentEditing == "Password"){
            self.Password.becomeFirstResponder()
        }
        if (currentEditing == "FirstName"){
            self.FirstName.becomeFirstResponder()
        }
        if (currentEditing == "LastName"){
            self.LastName.becomeFirstResponder()
        }
        if (currentEditing == "PhoneNumber"){
            
            self.PhoneNumber.becomeFirstResponder()
        }
        else
        {
            self.FirstName.becomeFirstResponder()
        }
    }
    
    func EditBegin(_ textField: UITextField){
        if(textField == self.Email){
            self.currentEditing = "Email"
        }
        if(textField == self.Password){
            self.currentEditing = "Password"
            self.SignUpButton.isEnabled = false
            self.SignUpButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.allFilled = 0
        }
        if(textField == self.FirstName){
            self.currentEditing = "FirstName"
        }
        if(textField == self.LastName){
            self.currentEditing = "LastName"
        }
        if(textField == self.PhoneNumber){
            self.currentEditing = "PhoneNumber"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.FirstName){
            self.FirstName.resignFirstResponder()
            self.LastName.becomeFirstResponder()
            return true
        }
        if(textField == self.LastName)
        {
            self.LastName.resignFirstResponder()
            self.Email.becomeFirstResponder()
            return true
        }
        if(textField == self.Email)
        {
            self.Email.resignFirstResponder()
            self.Password.becomeFirstResponder()
            return true
        }
        if(textField == self.Password)
        {
            self.Password.resignFirstResponder()
            self.PhoneNumber.becomeFirstResponder()
            return true
        }
        else{
            self.PhoneNumber.resignFirstResponder()
            if (self.SignUpButton.isEnabled == true){
                self.signUpHelper()
            }
            return true
        }
    }
    
    
    func TextFieldDidChange(_ textfield: UITextField){
        if(self.Password.text != "" && self.Email.text != "" && self.FirstName.text != ""
            && self.LastName.text! != "" && self.PhoneNumber.text! != ""){
            if (self.allFilled == 0){
                self.SignUpButton.isEnabled = true
                self.SignUpButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
                self.allFilled = 1
            }
        }
        else
        {
            self.SignUpButton.isEnabled = false
            self.SignUpButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.allFilled = 0
        }
        if(textfield == self.FirstName){
            let FirstNameText = NSMutableAttributedString(string: self.FirstName.text!)
            FirstNameText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, FirstNameText.length))
            self.FirstName.font = UIFont(name: "Avenir-Roman", size: 13)
            self.FirstName.attributedText = FirstNameText
            self.FirstName.textColor = UIColor.black
            
        }
        if(textfield == self.LastName)
        {
            let LastNameText = NSMutableAttributedString(string: self.LastName.text!)
            LastNameText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LastNameText.length))
            self.LastName.font = UIFont(name: "Avenir-Roman", size: 13)
            self.LastName.attributedText = LastNameText
            self.LastName.textColor = UIColor.black
        }
        if(textfield == self.Email)
        {
            let EmailText = NSMutableAttributedString(string: self.Email.text!)
            EmailText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailText.length))
            self.Email.font = UIFont(name: "Avenir-Roman", size: 13)
            self.Email.attributedText = EmailText
            self.Email.textColor = UIColor.black
        }
        if(textfield == self.PhoneNumber)
        {
            let PhoneNumberText = NSMutableAttributedString(string: self.PhoneNumber.text!)
            PhoneNumberText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PhoneNumberText.length))
            self.PhoneNumber.font = UIFont(name: "Avenir-Roman", size: 13)
            self.PhoneNumber.attributedText = PhoneNumberText
            self.PhoneNumber.textColor = UIColor.black
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
    
    func keyboardWillShow(_ notification:Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.NextButtonBottom.constant = keyboardHeight
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardHeight+53
        self.ScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.NextButtonBottom.constant = 0
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.ScrollView.contentInset = contentInset
    }
    
    func CancelDidTapped(){
        view.endEditing(true)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 251/256, green: 152/256, blue: 102/256, alpha: 1)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        self.signUpHelper()
    }
    
    func signUpHelper(){
        if (self.Email.text == "" || self.PhoneNumber.text == "" || self.Password.text == "" || self.LastName.text == "" || self.FirstName.text == "")
        {
            let alertController = UIAlertController(title: "Oops", message: "All text fields required", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.Email.text!, password: self.Password.text!, completion: {(user, error) in
                if error == nil{
                    
                    if let user = FIRAuth.auth()?.currentUser
                    {
                        let uid = user.uid
                        var userLLocation : String
                        if(isOffline == 1){
                            userLLocation = allLocations[0]
                        }
                        else{
                            userLLocation = OrderLocation
                            
                        }
                        let personalProfile : [String : String] = ["EmailAddress" : self.Email.text!, "PhoneNumber" : self.PhoneNumber.text!, "Password" : self.Password.text!, "Location" : userLLocation, "CurrentOrders" : "DEFAULT", "PastOrders" : "DEFAULT", "FirstName" : self.FirstName.text!, "LastName": self.LastName.text!]
                        databaseRef.child("Users/\(uid)").setValue(personalProfile)
                        
                        CU.setEmailAddress(self.Email.text!)
                        CU.setPhoneNumber(self.PhoneNumber.text!)
                        CU.setFirstName(self.FirstName.text!)
                        CU.setLastName(self.LastName.text!)
                        CU.setPassword(self.Password.text!)
                        if(isOffline == 1){
                            CU.setLocation("DEFAULT")
                        }
                        else{
                            CU.setLocation(OrderLocation)
                        }
                        CU.setUid(uid)
                        ReloadLocalOrder = 0
                        
                        if(isOffline == 1){
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let Profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                            self.present(Profile, animated: true, completion: nil)
                        }
                        else{
                            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.SignupToMainMenu), userInfo: nil, repeats: false)
                        }
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
    }
    
    func SignupToMainMenu() {
        self.performSegue(withIdentifier: "SignupToMainMenu", sender: self)
    }
    
}
