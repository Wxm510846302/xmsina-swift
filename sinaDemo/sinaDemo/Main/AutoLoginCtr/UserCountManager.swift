//
//  UserCountManager.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
import YYModel
//加密归档
@objcMembers
class UserCount: NSObject,NSSecureCoding,YYModel {
    //是否需要加密
    static var supportsSecureCoding: Bool = {return true}()
    
    //遵循归档协议
    var access_token:String?
    var expires_in:String?
    {
        didSet {
            let a = Int.init(expires_in ?? "0")
            remind_date = NSDate(timeIntervalSinceNow: TimeInterval.init(a!))
        }
    }
    var isRealName:String?
    var remind_in:String?
    var uid:String?
    var remind_date:NSDate?
    
    var screen_name:String?
    var descriptionK:String?
    var avatar_large:String?
    var followers_count:String?
    var friends_count:String?
    var statuses_count:String?
    var favourites_count:String?
    var created_at:String?
    
    
    // FIXME: - yymodel 归档智能是一般string类型数据
    /*
     required convenience init?(coder aDecoder: NSCoder) {
     self.init()
     self.yy_modelInit(with: aDecoder)
     }
     
     func encode(with aCoder: NSCoder) {
     self.yy_modelEncode(with: aCoder)
     }
     override var description: String {
     return yy_modelDescription()
     }
     */
    //    init(dic:[String:Any]){
    //        super.init()
    // setValuesForKeys(dic)//swift5 使用此方法需要给类加@objcMembers,但是int等类型还是不能加进去
    
    //    }
    override init() {
        super.init()
    }
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
//        self.access_token = keyedValues["access_token"] as? String
//        self.expires_in = keyedValues["expires_in"] as? String
//        self.isRealName = keyedValues["isRealName"] as? String
//        self.remind_in = keyedValues["remind_in"] as? String
//        self.uid = keyedValues["uid"] as? String
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override class func value(forUndefinedKey key: String) -> Any? {
        return ""
    }
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["descriptionK":"description"]
    }
    //    override var description: String{
    //        return dictionaryWithValues(forKeys: ["access_token","uid","expires_in","isRealName","remind_date"]).description
    //    }
    //从NSObject解析回来
    required init(coder aDecoder:NSCoder){
        
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeObject(forKey: "expires_in") as? String
        self.isRealName = aDecoder.decodeObject(forKey: "isRealName") as? String
        self.remind_in = aDecoder.decodeObject(forKey: "remind_in") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.remind_date = aDecoder.decodeObject(forKey: "remind_date") as? NSDate
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        self.descriptionK = aDecoder.decodeObject(forKey: "descriptionK") as? String
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        self.followers_count = aDecoder.decodeObject(forKey: "followers_count") as? String
        self.friends_count = aDecoder.decodeObject(forKey: "friends_count") as? String
        self.statuses_count = aDecoder.decodeObject(forKey: "statuses_count") as? String
        self.favourites_count = aDecoder.decodeObject(forKey: "favourites_count") as? String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as? String
      
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(access_token,forKey:"access_token")
        coder.encode(expires_in,forKey:"expires_in")
        coder.encode(isRealName,forKey:"isRealName")
        coder.encode(remind_in,forKey:"remind_in")
        coder.encode(uid,forKey:"uid")
        coder.encode(remind_date,forKey:"remind_date")
        coder.encode(screen_name,forKey:"screen_name")
        coder.encode(descriptionK,forKey:"descriptionK")
        coder.encode(avatar_large,forKey:"avatar_large")
        coder.encode(followers_count,forKey:"followers_count")
        coder.encode(friends_count,forKey:"friends_count")
        coder.encode(statuses_count,forKey:"statuses_count")
        coder.encode(favourites_count,forKey:"favourites_count")
        coder.encode(created_at,forKey:"created_at")
    }
    
    
}
class UserCountManager: NSObject {
    //    static let shared = UserCountManager.init()
    static var isLogin = false
    static var userModel:UserCount? = nil
    static var access_token = ""
    //保存用户信息
    static func saveUserCount(user:UserCount){
        let islogin = XMFileManager.init().saveToArchiver(obj: user, fileName: "userCount")
        UserCountManager.isLogin = islogin
        UserCountManager.userModel = user
    }
    //读取用户信息
    static func readUserCount()->UserCount?{
        let user = XMFileManager.init().getArchiver(fileName: "userCount")
        return user as? UserCount
    }
}
