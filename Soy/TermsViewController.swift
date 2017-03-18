//
//  TermsViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/16/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class TermsViewController: UIViewController {
    
    
    @IBOutlet weak var Input: UITextView!
    @IBOutlet weak var BorderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BorderView.layer.borderWidth = 1
        self.BorderView.layer.borderColor = UIColor(red: 227/256, green: 227/256, blue: 227/256, alpha: 1).cgColor
        self.BorderView.layer.cornerRadius = 5
        self.BorderView.layer.masksToBounds = true
        //-------------------------------------------------------------------------------------------------------
        let titleLabel = UILabel()
        let colour = UIColor.black
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 0.8 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "Terms of service", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //-------------------------------------------------------------------------------------------------------
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(TermsViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        //-------------------------------------------------------------------------------------------------------
        databaseRef.observe(.value, with: { (snapshot) in
            //-------------------------------------------------------------------------------------------------------
            let InputText = NSMutableAttributedString(string: (snapshot.value! as! NSDictionary)["Terms"] as! String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            InputText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, InputText.length))
            InputText.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, InputText.length))
            self.Input.attributedText = InputText
            self.Input.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            self.Input.font = UIFont(name: "Avenir-Roman", size: 13)
            //-------------------------------------------------------------------------------------------------------
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.Input.isSelectable = false
        self.Input.isEditable = false
    }
    
    func CancelDidTapped(){
        self.navigationController!.popViewController(animated: true)
    }
    
}
