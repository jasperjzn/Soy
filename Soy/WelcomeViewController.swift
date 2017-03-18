//
//  WelcomeViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 10/7/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var PickUpChineseBreakfast: UILabel!
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var ChaHuaImage: UIImageView!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LogoTop: NSLayoutConstraint!
    @IBOutlet weak var ChaHuaTop: NSLayoutConstraint!
    @IBOutlet weak var SignInBot: NSLayoutConstraint!
    @IBOutlet weak var SignUpBot: NSLayoutConstraint!
    @IBOutlet weak var ChaHuaWidth: NSLayoutConstraint!
    @IBOutlet weak var ChaHuaHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let BackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        BackButton.setImage(UIImage(named: "cut_back_white.png"), for: .normal)
        BackButton.addTarget(self, action: #selector(WelcomeViewController.CancelDidTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: BackButton)
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.LogoTop.constant = (screenSize.height/667)*26
        self.ChaHuaTop.constant = (screenSize.height/667)*(screenSize.height/667)*85
        self.SignInBot.constant = (screenSize.height/667)*28
        self.SignUpBot.constant = (screenSize.height/667)*21
        self.ChaHuaWidth.constant = (screenSize.height/667)*272
        self.ChaHuaHeight.constant = (screenSize.height/667)*180
        view.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        
        //        -------------------------------------------------------------------------------------------------------
        self.SignInButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.SignInButton.tintColor = UIColor.white
        self.SignInButton.titleLabel!.font =  UIFont(name: "Avenir-Roman", size: 12)
        let SignInButtonattributedTitle = NSAttributedString(string: "Already have account? Log In", attributes: [NSKernAttributeName: 0.8])
        self.SignInButton.setAttributedTitle(SignInButtonattributedTitle, for: .normal)
        //        -------------------------------------------------------------------------------------------------------
        self.SignUpButton.layer.cornerRadius = 5
        self.SignUpButton.layer.masksToBounds = true
        self.SignUpButton.backgroundColor = UIColor.white
        //        self.SignUpButton.setTitleColor(UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1), forState: UIControlState.Normal)
        self.SignUpButton.tintColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        self.SignUpButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 16)
        let SignUpButtonAttributedTitle = NSAttributedString(string: "Sign Up", attributes: [NSKernAttributeName: 1.0])
        self.SignUpButton.setAttributedTitle(SignUpButtonAttributedTitle, for: .normal)
        //        -------------------------------------------------------------------------------------------------------
        let pickupchinesebreakfastlabeltext = NSMutableAttributedString(
            string: "Chinese Breakfast Pick Up",
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 12)!])
        pickupchinesebreakfastlabeltext.addAttribute(NSKernAttributeName, value: 0.8, range: NSMakeRange(0, pickupchinesebreakfastlabeltext.length))
        self.PickUpChineseBreakfast.attributedText = pickupchinesebreakfastlabeltext
        self.PickUpChineseBreakfast.textColor = UIColor.white
        self.PickUpChineseBreakfast.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //        -------------------------------------------------------------------------------------------------------
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        UIApplication.shared.statusBarStyle = .lightContent
    //    }
    
    func CancelDidTapped(){
        UIApplication.shared.statusBarStyle = .default
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController!.popViewController(animated: true)
    }
}
