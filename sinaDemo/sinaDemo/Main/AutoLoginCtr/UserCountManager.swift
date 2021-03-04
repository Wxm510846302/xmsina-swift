//
//  UserCountManager.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
class UserCount: NSObject {
    var access_token:String = "2.00fvH9IDJIgYKC67eb4c7de6rNk6YC"
    var expires_in:TimeInterval = 0.0 {
        didSet {
            remind_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var isRealName = true
    var remind_in = 117696
    var uid = 2873312851
    var remind_date:NSDate?
    init(dic:[String:Any]){
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","uid","expires_in","isRealName","remind_date"]).description
    }
    // 从NSObject解析回来
    init(coder aDecoder:NSCoder!){
        super.init()
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as! String
        self.expires_in = aDecoder.decodeObject(forKey: "expires_in") as! TimeInterval
        self.isRealName = aDecoder.decodeObject(forKey: "isRealName") as! Bool
        self.remind_in = aDecoder.decodeObject(forKey: "remind_in") as! Int
        self.uid = aDecoder.decodeObject(forKey: "uid") as! Int
        self.remind_date = aDecoder.decodeObject(forKey: "remind_date") as? NSDate
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token,forKey:"access_token")
        aCoder.encode(expires_in,forKey:"expires_in")
        aCoder.encode(isRealName,forKey:"isRealName")
        aCoder.encode(remind_in,forKey:"remind_in")
        aCoder.encode(uid,forKey:"uid")
        aCoder.encode(remind_date,forKey:"remind_date")
    }
    //编码成object,哪些属性需要归档，怎么归档
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encode(access_token,forKey:"access_token")
        aCoder.encode(expires_in,forKey:"expires_in")
        aCoder.encode(isRealName,forKey:"isRealName")
        aCoder.encode(remind_in,forKey:"remind_in")
        aCoder.encode(uid,forKey:"uid")
        aCoder.encode(remind_date,forKey:"remind_date")
    }
}
class UserCountManager: NSObject {
    //    static let shared = UserCountManager.init()
    //保存用户信息
    static func saveUserCount(user:UserCount){
        _ = XMFileManager.init().saveToArchiver(obj: user, fileName: "account")
    }
    //读取用户信息
    static func readUserCount()->UserCount?{
        let user = XMFileManager.init().getArchiver(fileName: "account")
        return user as? UserCount
    }
}
