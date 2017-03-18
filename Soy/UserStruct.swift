//
//  UserStruct.swift
//  SoySoy
//
//  Created by ZhunengJ on 9/9/16.
//  Copyright © 2016 ZhunengJ. All rights reserved.
//

import Foundation

class UserStruct{
    
    var EmailAddress : String = ""
    var PhoneNumber : String = ""
    var Location : String = ""
    var Uid : String = ""
    var FirstName : String = ""
    var LastName : String = ""
    var Password : String = ""
    
    init(){
    }
    
    func getUid() -> String{
        return self.Uid
    }
    func setUid(_ input : String){
        self.Uid = input
    }
    func getEmailAddress() -> String {
        return self.EmailAddress
    }
    func getPhoneNumber() -> String {
        return self.PhoneNumber
    }
    func getLocation() -> String{
        return self.Location
    }
    func getFirstName() -> String{
        return self.FirstName
    }
    func getLastName() -> String{
        return self.LastName
    }
    func getPassword() -> String{
        return self.Password
    }
    func setEmailAddress(_ input : String){
        self.EmailAddress = input
    }
    func setPhoneNumber(_ input : String){
        self.PhoneNumber = input
    }
    func setLocation(_ input : String){
        self.Location = input
    }
    func setFirstName(_ input : String){
        self.FirstName = input
    }
    func setLastName(_ input : String){
        self.LastName = input
    }
    func setPassword(_ input : String){
        self.Password = input
    }
}
