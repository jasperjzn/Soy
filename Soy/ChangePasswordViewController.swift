//
//  ChangePasswordViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/23/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var OldPasswordLabel: UILabel!
    @IBOutlet weak var NewPasswordLabel: UILabel!
    @IBOutlet weak var NewPasswordVerifyLabel: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var WrongOldPasswordLabel: UILabel!
    @IBOutlet weak var OldPassword: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    @IBOutlet weak var NewPasswordVerify: UITextField!
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var InputViewTop: NSLayoutConstraint!
    var allFilled = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Change Password", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(ChangePasswordViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let SaveButtonTitle = NSMutableAttributedString(string: "SAVE", attributes: [NSKernAttributeName: 1.1])
        SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
        SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
        SaveButton.addTarget(self, action: #selector(ChangePasswordViewController.SaveDidTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
        self.navigationItem.rightBarButtonItem!.isEnabled = false
        //-------------------------------------------------------------------------------------------------------
        
        let OldPasswordLabelText = NSMutableAttributedString(
            string: "Old Password",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        OldPasswordLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, OldPasswordLabelText.length))
        self.OldPasswordLabel.attributedText = OldPasswordLabelText
        self.OldPasswordLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let NewPasswordLabelText = NSMutableAttributedString(
            string: "New Password",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        NewPasswordLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, NewPasswordLabelText.length))
        self.NewPasswordLabel.attributedText = NewPasswordLabelText
        self.NewPasswordLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let NewPasswordVerifyLabelText = NSMutableAttributedString(
            string: "New Password Verify",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        NewPasswordVerifyLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, NewPasswordVerifyLabelText.length))
        self.NewPasswordVerifyLabel.attributedText = NewPasswordVerifyLabelText
        self.NewPasswordVerifyLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let ErrorLabelText = NSMutableAttributedString(
            string: "Passwords not match",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        ErrorLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, ErrorLabelText.length))
        self.ErrorLabel.attributedText = ErrorLabelText
        self.ErrorLabel.textColor = UIColor(red: 255/256, green: 0/256, blue: 31/256, alpha: 1)
        self.ErrorLabel.textAlignment = .right
        self.ErrorLabel.alpha = 0
        //-------------------------------------------------------------------------------------------------------
        let WrongOldPasswordLabelText = NSMutableAttributedString(
            string: "Invalid Password",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        WrongOldPasswordLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, WrongOldPasswordLabelText.length))
        self.WrongOldPasswordLabel.attributedText = WrongOldPasswordLabelText
        self.WrongOldPasswordLabel.textColor = UIColor(red: 255/256, green: 0/256, blue: 31/256, alpha: 1)
        self.WrongOldPasswordLabel.textAlignment = .right
        self.WrongOldPasswordLabel.alpha = 0
        //-------------------------------------------------------------------------------------------------------
        self.OldPassword.addTarget(self, action: #selector(ChangePasswordViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.NewPassword.addTarget(self, action: #selector(ChangePasswordViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.NewPasswordVerify.addTarget(self, action: #selector(ChangePasswordViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        self.OldPassword.addTarget(self, action: #selector(ChangePasswordViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.NewPassword.addTarget(self, action: #selector(ChangePasswordViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        self.NewPasswordVerify.addTarget(self, action: #selector(ChangePasswordViewController.EditBegin), for: UIControlEvents.editingDidBegin)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.InputView.layer.borderWidth = 1
        self.InputView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.InputView.layer.cornerRadius = 5
        self.InputView.layer.masksToBounds = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.InputViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_
        animated: Bool) {
        self.OldPassword.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func TextFieldDidChange(textfield: UITextField){
        if(self.OldPassword.text != "" && self.NewPassword.text != "" && self.NewPasswordVerify.text != ""){
            if (self.allFilled == 0){
                self.allFilled = 1
                //-------------------------------------------------------------------------------------------------------
                let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
                SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
                let SaveButtonTitle = NSMutableAttributedString(string: "SAVE", attributes: [NSKernAttributeName: 1.1])
                SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
                SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
                SaveButton.addTarget(self, action: #selector(ChangePasswordViewController.SaveDidTapped), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
                self.navigationItem.rightBarButtonItem!.isEnabled = true
                //-------------------------------------------------------------------------------------------------------
            }
        }
        else
        {
            //-------------------------------------------------------------------------------------------------------
            let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
            SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
            let SaveButtonTitle = NSMutableAttributedString(string: "SAVE", attributes: [NSKernAttributeName: 1.1])
            SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
            SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
            SaveButton.addTarget(self, action: #selector(ChangePasswordViewController.SaveDidTapped), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
            self.navigationItem.rightBarButtonItem!.isEnabled = false
            //-------------------------------------------------------------------------------------------------------
            self.allFilled = 0
        }
        if(textfield == self.OldPassword){
            let OldPasswordText = NSMutableAttributedString(string: self.OldPassword.text!)
            OldPasswordText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, OldPasswordText.length))
            self.OldPassword.font = UIFont(name: "Avenir-Roman", size: 13)
            self.OldPassword.attributedText = OldPasswordText
            self.OldPassword.textColor = UIColor.black
            
        }
        if(textfield == self.NewPassword)
        {
            let NewPasswordText = NSMutableAttributedString(string: self.NewPassword.text!)
            NewPasswordText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, NewPasswordText.length))
            self.NewPassword.font = UIFont(name: "Avenir-Roman", size: 13)
            self.NewPassword.attributedText = NewPasswordText
            self.NewPassword.textColor = UIColor.black
        }
        if(textfield == self.NewPasswordVerify)
        {
            let NewPasswordVerifyText = NSMutableAttributedString(string: self.NewPasswordVerify.text!)
            NewPasswordVerifyText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, NewPasswordVerifyText.length))
            self.NewPasswordVerify.font = UIFont(name: "Avenir-Roman", size: 13)
            self.NewPasswordVerify.attributedText = NewPasswordVerifyText
            self.NewPasswordVerify.textColor = UIColor.black
        }
    }
    
    func EditBegin(textField: UITextField){
        let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let SaveButtonTitle = NSMutableAttributedString(string: "SAVE", attributes: [NSKernAttributeName: 1.1])
        SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
        SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
        SaveButton.addTarget(self, action: #selector(ChangePasswordViewController.SaveDidTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
        self.navigationItem.rightBarButtonItem!.isEnabled = false
        self.allFilled = 0
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.OldPassword){
            self.OldPassword.resignFirstResponder()
            self.NewPassword.becomeFirstResponder()
            return true
        }
        if(textField == self.NewPassword)
        {
            self.NewPassword.resignFirstResponder()
            self.NewPasswordVerify.becomeFirstResponder()
            return true
        }
        else{
            self.NewPasswordVerify.resignFirstResponder()
            if(self.navigationItem.rightBarButtonItem!.isEnabled == true){
                self.SaveDidTapped()
            }
            return true
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardHeight
        self.ScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.ScrollView.contentInset = contentInset
    }
    
    func CancelDidTapped(){
        view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
    
    func SaveDidTapped(){
        if (self.NewPasswordVerify.text!.characters.count < 6 || self.NewPassword.text!.characters.count < 6){
            let ErrorLabelText = NSMutableAttributedString(
                string: "6 characters minimum",
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Roman",
                    size: 10)!])
            ErrorLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, ErrorLabelText.length))
            self.ErrorLabel.attributedText = ErrorLabelText
            self.ErrorLabel.alpha = 1
        }else{
            if (self.NewPassword.text! != self.NewPasswordVerify.text!){
                let ErrorLabelText = NSMutableAttributedString(
                    string: "Passwords not match",
                    attributes: [NSFontAttributeName:UIFont(
                        name: "Avenir-Roman",
                        size: 10)!])
                ErrorLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, ErrorLabelText.length))
                self.ErrorLabel.attributedText = ErrorLabelText
                self.ErrorLabel.alpha = 1
            }else{
                self.ErrorLabel.alpha = 0
            }
        }
        if(self.OldPassword.text! != CU.getPassword()){
            self.WrongOldPasswordLabel.alpha = 1
        }else{
            self.WrongOldPasswordLabel.alpha = 0
        }
        
        if((self.NewPassword.text! == self.NewPasswordVerify.text!) && (self.OldPassword.text! == CU.getPassword()) && self.NewPassword.text!.characters.count > 5 && self.NewPasswordVerify.text!.characters.count > 5){
            let user = FIRAuth.auth()?.currentUser
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: CU.getEmailAddress(), password: CU.getPassword())
            user?.reauthenticate(with: credential) { error in
                if error != nil {
                    // An error happened.
                } else {
                    user?.updatePassword(self.NewPasswordVerify.text!) { error in
                        if error != nil {
                            print("ERROR")
                        } else {
                            databaseRef.child("Users/\(CU.getUid())/Password").setValue(self.NewPasswordVerify.text!)
                            CU.setPassword(self.NewPasswordVerify.text!)
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
}







