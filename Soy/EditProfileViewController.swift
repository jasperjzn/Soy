//
//  EditProfileViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/23/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseDatabase

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var InputViewTop: NSLayoutConstraint!
    @IBOutlet weak var ScrollContentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ChangePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Edit Profile", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(EditProfileViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let SaveButtonTitle = NSMutableAttributedString(string: "SAVE", attributes: [NSKernAttributeName: 1.1])
        SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
        SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
        SaveButton.addTarget(self, action: #selector(EditProfileViewController.SaveDidTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
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
        let PhoneNumberLabelText = NSMutableAttributedString(
            string: "Phone Number",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 10)!])
        PhoneNumberLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PhoneNumberLabelText.length))
        self.PhoneNumberLabel.attributedText = PhoneNumberLabelText
        self.PhoneNumberLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        self.InputView.layer.borderWidth = 1
        self.InputView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.InputView.layer.cornerRadius = 5
        self.InputView.layer.masksToBounds = true
        
        //        self.Email.addTarget(self, action: #selector(EditProfileViewController.TextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //        self.FirstName.addTarget(self, action: #selector(EditProfileViewController.TextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //        self.LastName.addTarget(self, action: #selector(EditProfileViewController.TextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //        self.PhoneNumber.addTarget(self, action: #selector(EditProfileViewController.TextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //        self.Email.addTarget(self, action: #selector(EditProfileViewController.EditBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //        self.FirstName.addTarget(self, action: #selector(EditProfileViewController.EditBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //        self.LastName.addTarget(self, action: #selector(EditProfileViewController.EditBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //        self.PhoneNumber.addTarget(self, action: #selector(EditProfileViewController.EditBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //-------------------------------------------------------------------------------------------------------
        let FirstNameText = NSMutableAttributedString(string: CU.getFirstName())
        FirstNameText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, FirstNameText.length))
        self.FirstName.font = UIFont(name: "Avenir-Roman", size: 13)
        self.FirstName.attributedText = FirstNameText
        self.FirstName.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        let LastNameText = NSMutableAttributedString(string: CU.getLastName())
        LastNameText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, LastNameText.length))
        self.LastName.font = UIFont(name: "Avenir-Roman", size: 13)
        self.LastName.attributedText = LastNameText
        self.LastName.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        let EmailText = NSMutableAttributedString(string: CU.getEmailAddress())
        EmailText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailText.length))
        self.Email.font = UIFont(name: "Avenir-Roman", size: 13)
        self.Email.attributedText = EmailText
        self.Email.textColor = UIColor.black
        self.Email.isEnabled = false
        //-------------------------------------------------------------------------------------------------------
        let PhoneNumberText = NSMutableAttributedString(string: CU.getPhoneNumber())
        PhoneNumberText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PhoneNumberText.length))
        self.PhoneNumber.font = UIFont(name: "Avenir-Roman", size: 13)
        self.PhoneNumber.attributedText = PhoneNumberText
        self.PhoneNumber.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        let screenSize: CGRect = UIScreen.main.bounds
        self.InputViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
        
        self.PasswordView.layer.borderWidth = 1
        self.PasswordView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.PasswordView.layer.cornerRadius = 5
        self.PasswordView.layer.masksToBounds = true
        
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
        let PasswordText = NSMutableAttributedString(string: "79sunsun")
        PasswordText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, PasswordText.length))
        self.Password.font = UIFont(name: "Avenir-Roman", size: 13)
        self.Password.attributedText = PasswordText
        self.Password.textColor = UIColor.black
        self.Password.isEnabled = false
        //-------------------------------------------------------------------------------------------------------
        self.ChangePasswordButton.tintColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.ChangePasswordButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 10)
        let ChangePasswordButtonTitle = NSAttributedString(string: "CHANGE", attributes: [NSKernAttributeName: 1])
        self.ChangePasswordButton.setAttributedTitle(ChangePasswordButtonTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
            self.PhoneNumber.becomeFirstResponder()
            return true
        }
        else
        {
            self.PhoneNumber.resignFirstResponder()
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
        databaseRef.child("Users/\(CU.getUid())/FirstName").setValue(self.FirstName.text!)
        databaseRef.child("Users/\(CU.getUid())/LastName").setValue(self.LastName.text!)
        databaseRef.child("Users/\(CU.getUid())/PhoneNumber").setValue(self.PhoneNumber.text!)
        
        CU.setFirstName(self.FirstName.text!)
        CU.setLastName(self.LastName.text!)
        CU.setPhoneNumber(self.PhoneNumber.text!)
        
        view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
}
