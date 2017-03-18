
//
//  BigPicViewController.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/6/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//



import UIKit

class BigPicViewController: UIViewController {
    
    
    @IBOutlet weak var ScrollHelperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var CurrentAmount: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var TotalAmountDue: UILabel!
    @IBOutlet weak var CheckoutButton: UIButton!
    @IBOutlet weak var ImageBottom: NSLayoutConstraint!
    @IBOutlet weak var OrderAmount: UILabel!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var MinusButton: UIButton!
    @IBOutlet weak var AddButtonBot: NSLayoutConstraint!
    @IBOutlet weak var MinusButtonBot: NSLayoutConstraint!
    @IBOutlet weak var AmountBot: NSLayoutConstraint!
    @IBOutlet weak var ViewBot: NSLayoutConstraint!
    @IBOutlet weak var ScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var ViewTop: NSLayoutConstraint!
    @IBOutlet weak var NameTop: NSLayoutConstraint!
    @IBOutlet weak var PriceTop: NSLayoutConstraint!
    @IBOutlet weak var AddButtonRight: NSLayoutConstraint!
    @IBOutlet weak var MinusButtonLeft: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        self.AddButtonBot.constant = (screenHeight/667)*(screenHeight/667)*34
        self.MinusButtonBot.constant = (screenHeight/667)*(screenHeight/667)*34
        self.AmountBot.constant = (screenHeight/667)*(screenHeight/667)*34
        self.ViewBot.constant = (screenHeight/667)*(screenHeight/667)*18
        self.ViewTop.constant = (screenHeight/667)*(screenHeight/667)*31
        self.ScrollViewTop.constant = (screenHeight/667)*(screenHeight/667)*20
        self.NameTop.constant = (screenHeight/667)*(screenHeight/667)*21
        self.PriceTop.constant = (screenHeight/667)*(screenHeight/667)*21
        self.AddButtonRight.constant = (screenWidth/375)*(screenWidth/375)*84
        self.MinusButtonLeft.constant = (screenWidth/375)*(screenWidth/375)*84
        
        self.ItemImage.image = tempImageG
        //-------------------------------------------------------------------------------------------------------
        let NameLabelText = NSMutableAttributedString(
            string: tempNameG,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        NameLabelText.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, NameLabelText.length))
        self.NameLabel.attributedText = NameLabelText
        self.NameLabel.textColor = UIColor.black
        //-------------------------------------------------------------------------------------------------------
        let PriceLabelText = NSMutableAttributedString(
            string: "$ " + tempPriceG,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 16)!])
        PriceLabelText.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, PriceLabelText.length))
        self.PriceLabel.attributedText = PriceLabelText
        self.PriceLabel.textColor = UIColor.black
        
        
        
        //-------------------------------------------------------------------------------------------------------
        self.DescriptionLabel.sizeToFit()
        self.DescriptionLabel.numberOfLines = 0
        let DescriptionLabelText = NSMutableAttributedString(
            string: tempDescriptionG,
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Roman",
                size: 13)!])
        DescriptionLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, DescriptionLabelText.length))
        self.DescriptionLabel.attributedText = DescriptionLabelText
        self.DescriptionLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        
        self.ScrollHelperViewHeight.constant = CGFloat((self.DescriptionLabel.text?.characters.count)!) * 85 / 150
        self.CurrentAmount.text = tempAmountG
        self.AddButton.setImage(UIImage(named: "cut_plus_151.png"), for: UIControlState.normal)
        self.AddButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.AddButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        self.MinusButton.setImage(UIImage(named: "cut_minus_151.png"), for: UIControlState.normal)
        self.MinusButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.MinusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        
        self.navigationController?.isNavigationBarHidden = true
        self.ImageBottom.constant = screenHeight - screenWidth * (240/349)
        let backButton = UIButton(frame: CGRect(x: 28, y: 35, width: 15, height: 15))
        backButton.setImage(UIImage(named: "cut_close_white.png"), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(BigPicViewController.CancelDidTapped), for: .touchUpInside)
        self.view.addSubview(backButton)
        self.OrderAmount.textColor = UIColor.white
        self.OrderAmount.text = String(LocalOrder.getCounts())
        self.OrderAmount.backgroundColor = UIColor.clear
        self.OrderAmount.layer.borderWidth = 1.5
        self.OrderAmount.layer.borderColor = UIColor.white.cgColor
        self.OrderAmount.text = String(LocalOrder.getCounts())
        self.OrderAmount.font = UIFont(name: "Avenir-Heavy", size: 12)
        self.OrderAmount.textAlignment = NSTextAlignment.center
        
        if(LocalOrder.getAmountByName(tempNameG) == 0.0){
            self.CurrentAmount.text = "0"
            self.CurrentAmount.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        }
        else
        {
            self.CurrentAmount.text = String(Int(LocalOrder.getAmountByName(tempNameG)))
            self.CurrentAmount.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        }
        //----------------------------------------------------------------------------------------------------
        self.CheckoutButton.tintColor = UIColor.white
        self.CheckoutButton.titleLabel!.font =  UIFont(name: "Avenir-Heavy", size: 15)
        let CheckOutButtonTitle = NSAttributedString(string: "CHECK OUT", attributes: [NSKernAttributeName: 0.5])
        self.CheckoutButton.setAttributedTitle(CheckOutButtonTitle, for: .normal)
        self.CheckoutButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        //----------------------------------------------------------------------------------------------------
        
        if (LocalOrder.getTotal() == 0.0){
            //-------------------------------------------------------------------------------------------------------
            let TotalAmountDueLabelText = NSMutableAttributedString(
                string: "$0",
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Heavy",
                    size: 14)!])
            TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
            self.TotalAmountDue.attributedText = TotalAmountDueLabelText
            self.TotalAmountDue.textColor = UIColor.white
            self.TotalAmountDue.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
            //-------------------------------------------------------------------------------------------------------
            self.CheckoutButton.isEnabled = false
            self.CheckoutButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        }
        else
        {
            //-------------------------------------------------------------------------------------------------------
            let TotalAmountDueLabelText = NSMutableAttributedString(
                string: "$" + String(LocalOrder.getTotal()),
                attributes: [NSFontAttributeName:UIFont(
                    name: "Avenir-Heavy",
                    size: 14)!])
            TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
            self.TotalAmountDue.attributedText = TotalAmountDueLabelText
            self.TotalAmountDue.textColor = UIColor.white
            
            self.TotalAmountDue.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
            //-------------------------------------------------------------------------------------------------------
            self.CheckoutButton.isEnabled = true
            self.CheckoutButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        }
    }
    
    @IBAction func AddOne(_ sender: Any) {
        if(LocalOrder.getTotal() == 0.0){
            self.CheckoutButton.isEnabled = true
            self.CheckoutButton.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LiftMenu"), object: nil)
        }
        if(self.CurrentAmount.text == "0"){
            self.CurrentAmount.textColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        }
        self.CurrentAmount.text = String(Int(self.CurrentAmount.text!)! + 1)
        LocalOrder.addAmountByName(self.NameLabel.text!)
        self.OrderAmount.text = String(LocalOrder.getCounts())
        //-------------------------------------------------------------------------------------------------------
        let TotalAmountDueLabelText = NSMutableAttributedString(
            string: "$" + String(LocalOrder.getTotal()),
            attributes: [NSFontAttributeName:UIFont(
                name: "Avenir-Heavy",
                size: 14)!])
        TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
        self.TotalAmountDue.attributedText = TotalAmountDueLabelText
        self.TotalAmountDue.textColor = UIColor.white
        self.TotalAmountDue.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
        //-------------------------------------------------------------------------------------------------------
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMainMenuTotalAmount"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
    }
    
    @IBAction func RemoveOne(_ sender: Any) {
        if(self.CurrentAmount.text == "1"){
            self.CurrentAmount.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        }
        if(Double(self.CurrentAmount.text!)! >= 1){
            self.CurrentAmount.text = String(Int(self.CurrentAmount.text!)! - 1)
            LocalOrder.reduceAmountByName(self.NameLabel.text!)
            self.OrderAmount.text = String(LocalOrder.getCounts())
            if (LocalOrder.getTotal() == 0.0){
                //-------------------------------------------------------------------------------------------------------
                let TotalAmountDueLabelText = NSMutableAttributedString(
                    string: "$0",
                    attributes: [NSFontAttributeName:UIFont(
                        name: "Avenir-Heavy",
                        size: 14)!])
                TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
                self.TotalAmountDue.attributedText = TotalAmountDueLabelText
                self.TotalAmountDue.textColor = UIColor.white
                
                self.TotalAmountDue.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
                //-------------------------------------------------------------------------------------------------------
                self.CheckoutButton.isEnabled = false
                self.CheckoutButton.backgroundColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DropMenu"), object: nil)
            }
            else
            {
                //-------------------------------------------------------------------------------------------------------
                let TotalAmountDueLabelText = NSMutableAttributedString(
                    string: "$" + String(LocalOrder.getTotal()),
                    attributes: [NSFontAttributeName:UIFont(
                        name: "Avenir-Heavy",
                        size: 14)!])
                TotalAmountDueLabelText.addAttribute(NSKernAttributeName, value: 0.5, range: NSMakeRange(0, TotalAmountDueLabelText.length))
                self.TotalAmountDue.attributedText = TotalAmountDueLabelText
                self.TotalAmountDue.textColor = UIColor.white
                self.TotalAmountDue.backgroundColor = UIColor(red: 251/256, green: 153/256, blue: 102/256, alpha: 1)
                //-------------------------------------------------------------------------------------------------------
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMainMenuTotalAmount"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpgradeMenu"), object: nil)
        }
    }
    
    func CancelDidTapped(){
        UIApplication.shared.statusBarStyle = .default
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    //    @IBAction func CheckoutDidTapped(sender: AnyObject) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let Checkout = storyboard.instantiateViewController(withIdentifier: "CheckoutVC")
    //        self.present(Checkout, animated: true, completion: nil)
    //
    //    }
    
}
