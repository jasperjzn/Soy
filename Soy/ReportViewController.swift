//
//  ReportViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/27/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ReportViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var FeedbackView: UIView!
    @IBOutlet weak var ThanksTextView: UITextView!
    @IBOutlet weak var GetBackToYouTextView: UITextView!
    
    @IBOutlet weak var BorderView: UIView!
    @IBOutlet weak var BorderViewBot: NSLayoutConstraint!
    @IBOutlet weak var Input: UITextView!
    var contactEmail = String()
    
    var allFilled = 0
    
    @IBOutlet weak var ShadeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allFilled = 0
        self.ShadeView.backgroundColor = UIColor.black
        self.ShadeView.alpha = 0
        
        self.FeedbackView.layer.cornerRadius = 5
        self.FeedbackView.layer.masksToBounds = true
        self.FeedbackView.alpha = 0
        //-------------------------------------------------------------------------------------------------------
        let ThanksTextViewText = NSMutableAttributedString(string: "Thanks for your feedback!")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        ThanksTextViewText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, ThanksTextViewText.length))
        ThanksTextViewText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, ThanksTextViewText.length))
        self.ThanksTextView.attributedText = ThanksTextViewText
        self.ThanksTextView.textAlignment = .center
        self.ThanksTextView.textColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        self.ThanksTextView.font = UIFont(name: "Avenir-Heavy", size: 17)
        self.ThanksTextView.isSelectable = false
        self.ThanksTextView.isEditable = false
        //-------------------------------------------------------------------------------------------------------
        let GetBackToYouTextViewText = NSMutableAttributedString(string: "We will get back to you via email as soon as possible!")
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 3
        GetBackToYouTextViewText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle1, range:NSMakeRange(0, GetBackToYouTextViewText.length))
        GetBackToYouTextViewText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, ThanksTextViewText.length))
        self.GetBackToYouTextView.attributedText = GetBackToYouTextViewText
        self.GetBackToYouTextView.textAlignment = .center
        self.GetBackToYouTextView.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        self.GetBackToYouTextView.font = UIFont(name: "Avenir-Roman", size: 12)
        self.GetBackToYouTextView.isSelectable = false
        self.GetBackToYouTextView.isEditable = false
        //-------------------------------------------------------------------------------------------------------
        self.BorderView.layer.borderWidth = 1
        self.BorderView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.BorderView.layer.cornerRadius = 5
        self.BorderView.layer.masksToBounds = true
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Send us a message", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(ReportViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 18))
        SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let SaveButtonTitle = NSMutableAttributedString(string: "SEND", attributes: [NSKernAttributeName: 1.1])
        SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
        SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
        SaveButton.addTarget(self, action: #selector(ReportViewController.SendDidTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        databaseRef.observe(.value, with: { (snapshot) in
            self.contactEmail = (snapshot.value! as! NSDictionary)["ContactEmail"] as! String
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReportViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReportViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.Input.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.BorderViewBot.constant = 27 + keyboardHeight
    }
    
    func keyboardWillHide(notification:NSNotification) {
        self.BorderViewBot.constant = 27
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let InputText = NSMutableAttributedString(string: self.Input.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        InputText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, InputText.length))
        InputText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, InputText.length))
        self.Input.attributedText = InputText
        self.Input.textColor = UIColor.black
        self.Input.font = UIFont(name: "Avenir-Roman", size: 13)
        
        if (self.Input.text != ""){
            if(self.allFilled == 0){
                //-------------------------------------------------------------------------------------------------------
                let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 18))
                SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
                let SaveButtonTitle = NSMutableAttributedString(string: "SEND", attributes: [NSKernAttributeName: 1.1])
                SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 251/256, green:153/256, blue: 102/256, alpha: 1), range: NSMakeRange(0, SaveButtonTitle.length))
                SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
                SaveButton.addTarget(self, action: #selector(ReportViewController.SendDidTapped), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
                //-------------------------------------------------------------------------------------------------------
                self.allFilled = 1
            }
        }
        else
        {
            if(self.allFilled == 1){
                //-------------------------------------------------------------------------------------------------------
                let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 18))
                SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
                let SaveButtonTitle = NSMutableAttributedString(string: "SEND", attributes: [NSKernAttributeName: 1.1])
                SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1), range: NSMakeRange(0,SaveButtonTitle.length))
                SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
                SaveButton.addTarget(self, action: #selector(ReportViewController.SendDidTapped), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                //-------------------------------------------------------------------------------------------------------
                self.allFilled = 0
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.view.endEditing(true)
            self.SendDidTapped()
            return false
        }
        return true
    }
    
    func SendDidTapped(){
        self.Input.resignFirstResponder()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "PST")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let completeTime = formatter.string(from: date as Date)
        
        let ReportDict : [String : String] = ["EmailAddress" : CU.getEmailAddress(), "FirstName" : CU.getFirstName(), "LastName" : CU.getLastName(), "Uid": CU.getUid(),"Content": self.Input.text!]
        databaseRef.child("Reports/\(completeTime)").setValue(ReportDict)
        
        self.FeedbackView.alpha = 1
        self.ShadeView.alpha = 0.5
        self.Input.text = ""
        self.Input.isEditable = false
        self.Input.isSelectable = false
        //-------------------------------------------------------------------------------------------------------
        let SaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 18))
        SaveButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 13)
        let SaveButtonTitle = NSMutableAttributedString(string: "SEND", attributes: [NSKernAttributeName: 1.1])
        SaveButtonTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 251/256, green:153/256, blue: 102/256, alpha: 0.5), range: NSMakeRange(0, SaveButtonTitle.length))
        SaveButton.setAttributedTitle(SaveButtonTitle, for: .normal)
        SaveButton.addTarget(self, action: #selector(ReportViewController.SendDidTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: SaveButton)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        //-------------------------------------------------------------------------------------------------------
        self.navigationController?.navigationBar.isTranslucent = true
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.CancelDidTapped), userInfo: nil, repeats: false)
        
    }
    
    func CancelDidTapped(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.popViewController(animated: true)
    }
    
}
