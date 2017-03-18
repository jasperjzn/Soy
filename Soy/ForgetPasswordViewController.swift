//
//  ForgetPasswordViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/16/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PleaseCheckEmailLabel: UILabel!
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var InputViewTop: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBot: NSLayoutConstraint!
    
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var InvalidEmailLabel: UILabel!
    @IBOutlet weak var ErrorViewTryAnotherOneButton: UIButton!
    @IBOutlet weak var ErrorViewBackToLoginButton: UIButton!
    
    @IBOutlet weak var SuccessView: UIView!
    @IBOutlet weak var PasswordResetEmailSentLabel: UILabel!
    @IBOutlet weak var SuccessViewToLogin: UIButton!
    
    var allFilled = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Forget Password", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(ForgetPasswordViewController.CancelDidTapped), for: .touchUpInside)
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
        let EmailFieldText = NSMutableAttributedString(string: " ")
        EmailFieldText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, EmailFieldText.length))
        self.EmailField.font = UIFont(name: "Avenir-Roman", size: 13)
        self.EmailField.attributedText = EmailFieldText
        self.EmailField.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        let PleaseCheckEmailLabelText = NSMutableAttributedString(
            string: "Please check your email to reset the Password.",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 12)!])
        PleaseCheckEmailLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, PleaseCheckEmailLabelText.length))
        self.PleaseCheckEmailLabel.attributedText = PleaseCheckEmailLabelText
        self.PleaseCheckEmailLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        self.sendButton.tintColor = UIColor.white
        self.sendButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 14)
        let sendButtonTitle = NSAttributedString(string: "Send", attributes: [NSKernAttributeName: 0.5])
        self.sendButton.setAttributedTitle(sendButtonTitle, for: .normal)
        self.sendButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        let InvalidEmailLabelText = NSMutableAttributedString(
            string: "Invalid Email Address",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 17)!])
        InvalidEmailLabelText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, InvalidEmailLabelText.length))
        self.InvalidEmailLabel.attributedText = InvalidEmailLabelText
        self.InvalidEmailLabel.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        self.ErrorViewTryAnotherOneButton.layer.cornerRadius = 5
        self.ErrorViewTryAnotherOneButton.layer.masksToBounds = true
        self.ErrorViewTryAnotherOneButton.tintColor = UIColor.white
        self.ErrorViewTryAnotherOneButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 14)
        let ErrorViewTryAnotherOneButtonTitle = NSAttributedString(string: "Try Another Email", attributes: [NSKernAttributeName: 0.5])
        self.ErrorViewTryAnotherOneButton.setAttributedTitle(ErrorViewTryAnotherOneButtonTitle, for: .normal)
        self.ErrorViewTryAnotherOneButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        self.ErrorViewBackToLoginButton.tintColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.ErrorViewBackToLoginButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 12)
        let ErrorViewBackToLoginButtonTitle = NSAttributedString(string: "Back to Sign in", attributes: [NSKernAttributeName: 0.5])
        self.ErrorViewBackToLoginButton.setAttributedTitle(ErrorViewBackToLoginButtonTitle, for: .normal)
        //-------------------------------------------------------------------------------------------------------
        self.SuccessViewToLogin.layer.cornerRadius = 5
        self.SuccessViewToLogin.layer.masksToBounds = true
        self.SuccessViewToLogin.tintColor = UIColor.white
        self.SuccessViewToLogin.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 14)
        let SuccessViewToLoginTitle = NSAttributedString(string: "Back to Sign in", attributes: [NSKernAttributeName: 0.5])
        self.SuccessViewToLogin.setAttributedTitle(SuccessViewToLoginTitle, for: .normal)
        self.SuccessViewToLogin.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        self.ShadowView.alpha = 0
        self.ShadowView.backgroundColor = UIColor.black
        self.ErrorView.alpha = 0
        self.ErrorView.layer.cornerRadius = 5
        self.ErrorView.layer.masksToBounds = true
        self.SuccessView.alpha = 0
        self.SuccessView.layer.cornerRadius = 5
        self.SuccessView.layer.masksToBounds = true
        
        self.InputView.layer.borderWidth = 1
        self.InputView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.InputView.layer.cornerRadius = 5
        self.InputView.layer.masksToBounds = true
        
        self.EmailField.addTarget(self, action: #selector(LoginViewController.TextFieldDidChange), for: UIControlEvents.editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.sendButton.isEnabled = false
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.InputViewTop.constant = (screenSize.height/667)*(screenSize.height/667)*27
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.EmailField.becomeFirstResponder()
        self.EmailField.text = ""
    }
    
    func TextFieldDidChange(_ textfield: UITextField){
        if(self.EmailField.text != ""){
            if (self.allFilled == 0){
                self.sendButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
                self.allFilled = 1
                self.sendButton.isEnabled = true
            }
        }
        else
        {
            self.sendButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.allFilled = 0
            self.sendButton.isEnabled = false
        }
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.sendButtonBot.constant = keyboardHeight
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.sendButtonBot.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendResetPasswordEmail()
        return true
    }
    @IBAction func SendButton(_ sender: Any) {
        self.sendResetPasswordEmail()
    }
    
    func sendResetPasswordEmail(){
        let email = self.EmailField.text
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if error != nil {
                self.showMessage(0)
            } else {
                self.showMessage(1)
            }
        }
    }
    
    func showMessage(_ emailValid : Int){
        self.navigationController?.navigationBar.isTranslucent = true
        if (emailValid == 0){
            self.ShadowView.alpha = 0.5
            self.ErrorView.alpha = 1
            self.EmailField.isEnabled = false
        }
        else
        {
            self.ShadowView.alpha = 0.5
            self.SuccessView.alpha = 1
            self.EmailField.isEnabled = false
        }
    }
    @IBAction func ErrorViewTryAgain(_ sender: Any) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.ShadowView.alpha = 0
        self.ErrorView.alpha = 0
        self.EmailField.isEnabled = true
        self.EmailField.text = ""
        self.EmailField.becomeFirstResponder()
    }
    @IBAction func ErrorViewBackToLogin(_ sender: Any) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func SuccessViewToLogin(_ sender: Any) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        self.navigationController!.popViewController(animated: true)
    }
    
    func CancelDidTapped(){
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
}
