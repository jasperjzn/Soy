//
//  TestViewController.swift
//  Soy
//
//  Created by ZhunengJ on 11/20/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class TestViewController: UIViewController {
    var tempList : [String] = []
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        databaseRef.child("LocationAddress").observe(.value, with: { (snapshot) in
            allLocationsAddress = snapshot.value as! [String : String]
            for (eachLocation, _) in allLocationsAddress{
                self.tempList.append(eachLocation)
            }
            print(self.tempList)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
