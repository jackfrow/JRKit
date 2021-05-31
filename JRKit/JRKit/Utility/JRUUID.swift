//
//  JRUUID.swift
//  JRKit
//
//  Created by jackfrow on 2021/5/31.
//

import Foundation
import UIKit

let id = "jackfrow.JRKit"
let account = "UUID"





//利用keychain实现uuid
struct JRUUID {
    
    public static func GetUUID() -> String{
        
        let uuid = YYKeychain.getPasswordForService(id, account: account)
        if let uid = uuid {
            return uid
        }
        
        let uid = UUID().uuidString
        YYKeychain.setPassword(uid, forService: id, account: account)
        return uid
    }

}
