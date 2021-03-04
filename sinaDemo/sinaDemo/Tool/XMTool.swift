//
//  SceneDelegate.swift
//  sinaDemo
//
//  Created by admin on 2021/2/26.
// this is master change

import Foundation
import CommonCrypto
import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let isPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
let isPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
let isPhoneX = Bool(kScreenWidth >= 375.0 && kScreenHeight >= 812.0 && isPhone)
//导航条的高度
let kNavigationHeight = CGFloat(isPhoneX ? 88 : 64)
//状态栏高度
let kStatusBarHeight = CGFloat(isPhoneX ? 44 : 20)
//tabbar高度
let kTabBarHeight = CGFloat(isPhoneX ? (49 + 34) : 49)
//顶部安全区域远离高度
let kTopSafeHeight = CGFloat(isPhoneX ? 44 : 0)
//底部安全区域远离高度
let kBottomSafeHeight = CGFloat(isPhoneX ? 34 : 0)

//func rawWidthValue(value:CGFloat) -> CGFloat {
//    
//    
//    
//}
//日志输出
func XMLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line)  {
    
    #if DEBUG
    //        let path  = (file as NSString).deletingLastPathComponent
    let ext  = (file as NSString).lastPathComponent
    print("XMLog - file:\(ext) Func:[\(funcName)] Line:\(lineNum) msg:\(message)")
    
    #endif
}
extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
}
extension String {
    //    如果需要小写，将"%02X"改成"%02x"
    var MD5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        //ios13 后不推荐md5了，推荐SHA256
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        //        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        //ios13 后不推荐md5了，推荐SHA256
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        //        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

extension UIButton{
    static func creatBtn(imgName:String,bgImgName:String) -> UIButton{
        let button = UIButton()
        button.setImage(UIImage(named: imgName), for: .normal)
        button.setImage(UIImage(named: imgName), for: .highlighted)
        button.setBackgroundImage(UIImage(named: bgImgName), for: .normal)
        button.setBackgroundImage(UIImage(named: bgImgName), for: .highlighted)
        button.sizeToFit()
        return button
    }
    convenience init(imgName:String,bgImgName:String){
        self.init()
        setImage(UIImage(named: imgName), for: .normal)
        setImage(UIImage(named: imgName), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImgName), for: .normal)
        setBackgroundImage(UIImage(named: bgImgName), for: .highlighted)
        sizeToFit()
    }
    
    struct AssociatedKeys{
        static var defaultInterval : TimeInterval = 5 //间隔时间
        
        static var A_customInterval = "customInterval"
        
        static var A_ignoreInterval = "ignoreInterval"
    }
    
    var customInterval: TimeInterval{
        get{ let A_customInterval = objc_getAssociatedObject(self, &AssociatedKeys.A_customInterval)
            
            if let time = A_customInterval{
                return time as! TimeInterval
            }else{
                return AssociatedKeys.defaultInterval
                
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.A_customInterval, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var ignoreInterval: Bool{
        get{
            return (objc_getAssociatedObject(self, &AssociatedKeys.A_ignoreInterval) != nil)
            
        }
        
        set{objc_setAssociatedObject(self, &AssociatedKeys.A_ignoreInterval, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
        }
        
    }
    //由于在swift4中 initialize（）这个方法已经被废弃了  所以需要自己写一个方法，并在Appdelegate 中调用此方法
    public class func initializeMethod(){
        if self == UIButton.self {
            let systemSel = #selector(UIButton.sendAction(_:to:for:))
            
            let sSel = #selector(UIButton.mySendAction(_: to: for:))
            
            let systemMethod = class_getInstanceMethod(self, systemSel)
            
            let sMethod = class_getInstanceMethod(self, sSel)
            
            let isTrue = class_addMethod(self, systemSel, method_getImplementation(sMethod!), method_getTypeEncoding(sMethod!))
            
            if isTrue{
                class_replaceMethod(self, sSel, method_getImplementation(systemMethod!), method_getTypeEncoding(systemMethod!))
                
            }else{
                method_exchangeImplementations(systemMethod!, sMethod!)
            }
        }
        
    }
    
    @objc private dynamic func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?){
        if !ignoreInterval{
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+customInterval, execute: {
                self.isUserInteractionEnabled = true
                
            })
            
        }
        mySendAction(action, to: target, for: event)
    }
    
}

//enum MaskType {
//    //显示HUD的同时允许用户点击其他地方
//    case LKProgressHUDMaskTypeNone
//    //不允许用户点击其他地方
//    case LKProgressHUDMaskTypeClear
//    //不允许用户点击其他地方,并且添加灰色覆盖背景
//    case LKProgressHUDMaskTypeBlack
//    //不允许用户点击其他地方,并且添加渐变覆盖背景
//    case LKProgressHUDMaskTypeGradient
//}
//class XMProgress: UIView {
//    static func show() {
//
//    }
//}
extension UIColor {
    
    /// 16进制转color UIColor().hexStringToColor(hexString: "#6CB8FF")
    /// - Parameter hexString: 16进制字符串
    /// - Returns: 颜色
    public func hexStringToColor(hexString: String) -> UIColor{
        
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") || cString.hasPrefix("0x") {
            cString.remove(at: cString.index(cString.startIndex, offsetBy: 2))
            //            cString.removeFirst(2) 6CB8FF
            //            cString.removeLast(6) 0X
        }
        if cString.hasPrefix("#") {
            cString.removeFirst()
        }
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt64 = 0x0
        var g: UInt64 = 0x0
        var b: UInt64 = 0x0
        Scanner.init(string: rString).scanHexInt64(&r)
        Scanner.init(string: gString).scanHexInt64(&g)
        Scanner.init(string: bString).scanHexInt64(&b)
        
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}


class XMFileManager: NSObject {
    
    /// 用户偏好设置
    /// - Parameters:
    ///   - value:value
    ///   - key: key
    /// - Returns: 是否成功
    func saveToUserDf(value:Any,key:String) -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: key)
            return UserDefaults.standard.synchronize()
        } catch  {
            print("模型转data失败: \(error)")
        }
        return false
        
    }
    func getFromUserDf(key:String) -> Any? {
        
        let data:Data? = UserDefaults.standard.value(forKey: key) as? Data
        if let data = data {
            do {
                let model:Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) ?? nil
                return model
            } catch  {
                
            }
        }
        
        return nil
    }
    
    func removeUserDf(key:String)  {
        UserDefaults.standard.removeObject(forKey: key)
    }
    /// 归档操作
    /// - Returns: 是否成功
    func saveToArchiver(obj:Any,fileName:String) -> Bool {
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent( fileName + ".archiver")
        print("用户信息路径:\(filePath)")
        // 保存
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
            do {
                _ = try data.write(to: URL(fileURLWithPath: filePath))
                print("写入成功")
                return true
            } catch {
                print("data写入本地失败: \(error)")
            }
        } catch  {
            print("模型转data失败: \(error)")
            
        }
        return false
    }
    
    /// 查询归档
    /// - Parameter fileName: 名称
    /// - Returns: 数据
    func getArchiver(fileName:String) -> Any? {
        // 路径
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent( fileName + ".archiver")
        do {
            let data = try Data.init(contentsOf: URL(fileURLWithPath: filePath))
            // 当用户首次登陆, 直接从沙盒获取数据, 就会为nil  所以这里需要使用as?
            let model:Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) ?? nil
            return model
        } catch {
            print("获取data数据失败: \(error)")
        }
        return nil
    }
    
    /// 删除Archiver本地文件
    /// - Parameter fileName: path
    func deleteArchiver(fileName:String) {
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent( fileName + ".archiver")
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: filePath))
        } catch  {
            
        }
    }
    
    /// 保存到钥匙串
    /// - Parameters:
    ///   - key: key
    ///   - value: Data类型数据
    func savetoKeyChain(key:String,value:Any) {
        
        do {
            let valueData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            let service = Bundle.main.bundleIdentifier!
            let secItem = [
                kSecClass as NSString : kSecClassGenericPassword as NSString,
                kSecAttrService as NSString : service,
                kSecAttrAccount as NSString : key,
                kSecValueData : valueData
            ] as NSDictionary
            
            var result:CFTypeRef?
            let status = Int(SecItemAdd(secItem, &result))
            switch status {
            case Int(errSecSuccess):
                print("Successfully stored the value")
            case Int(errSecDuplicateItem):
                print("this item is already saved, Cannot duplicate it")
                self.updateKeyChain(keyToSearchfor: key, newValue: value)
            default:
                print("An error occurred with code\(status)")
            }
        } catch  {
            print("An error occurred with code\(error)")
        }
        
    }
    
    //在钥匙串中查找数据
    
    /****查找钥匙串中的值
     
     SecItemCopyMatching(CFDictionary, UnsafeMutablePointer<CFTypeRef?>?)
     
     1.构建一个字典，天剑kSecClass键，设置键的值来标识查找项的类型。 例如：kSecClassGenericPassword
     
     2.添加kSecAttrService键。取值为查找项服务的字符串，所有应用应采用相同的值，这样任意应用写到钥匙串的数据，其他应用可以访问
     
     3.添加kSecAttrAccount键，取值为钥匙串已存储项对应的键
     
     4.获取特定属性的值：创建修改日期，需要向字典中添加kSecReturnAttributes,并将其值设置为kCFBooleanTrue
     如果设置CFDictionary键为 kSecReturnAttributes键，则返回值为nil或CFDictionaryRef隐含类型
     如果为kSecReturnData添加到字典，返回类型是CDDataRef
     **/
    
    func queryFromKeyChain(keyToSearchfor:String) -> Any{
        let service = Bundle.main.bundleIdentifier
        let query = [kSecClass as NSString : kSecClassGenericPassword as NSString,
                     kSecAttrAccount as NSString : keyToSearchfor,
                     kSecAttrService as NSString : service!,
                     kSecReturnAttributes as NSString : kCFBooleanTrue!
        ] as NSDictionary
        
        var valueAttributes : CFTypeRef?
        let results = Int(SecItemCopyMatching(query, &valueAttributes))
        if results == Int(errSecSuccess) {
            
            let attributes = valueAttributes! as! NSDictionary
            
            //            let key = attributes[kSecAttrAccount as NSString] as! String
            //            let accessGroup = attributes[kSecAttrAccessGroup as NSString] as! String
            //            let createDate = attributes[kSecAttrCreationDate as NSString] as! NSDate
            //            let modifiedDate = attributes[kSecAttrModificationDate as NSString] as! NSDate
            //            let serviceValue = attributes[kSecAttrService as NSString] as! String
            //            print(attributes)
            //            print(key)
            //            print(accessGroup)
            //            print(createDate)
            //            print(modifiedDate)
            //            print(serviceValue)
            return attributes
            
            
        }else{
            print("Error happened with code:\(results)")
        }
        return ["Error":""]
    }
    
    /// 取出钥匙串的数据
    /// - Parameter keyToSearchfor: key
    /// - Returns: value
    func queryDataFromKeyChain(keyToSearchfor:String) -> Any?{
        let service = Bundle.main.bundleIdentifier
        let query = [kSecClass as NSString : kSecClassGenericPassword as NSString,
                     kSecAttrAccount as NSString : keyToSearchfor,
                     kSecAttrService as NSString : service!,
                     kSecReturnData as NSString : kCFBooleanTrue!
        ] as NSDictionary
        
        var returnedData : CFTypeRef?
        let results = Int(SecItemCopyMatching(query, &returnedData))
        if results == Int(errSecSuccess) {
            let data = returnedData! as! Data
            do {
                let ret = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                return ret ?? nil
            } catch  {
                return nil
            }
        }else{
            print("Error happened with code:\(results)")
        }
        return nil
    }
    
    /// 更新钥匙串
    /// - Parameters:
    ///   - keyToSearchfor: key
    ///   - value: newvalue
    func updateKeyChain(keyToSearchfor:String,newValue:Any) {
        
        let service = Bundle.main.bundleIdentifier
        
        do {
            let newData = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
            
            let query = [kSecClass as NSString: kSecClassGenericPassword as NSString,
                         kSecAttrService as NSString: service as Any,
                         kSecAttrAccount as NSString: keyToSearchfor] as NSDictionary
            
            var result: CFTypeRef?
            let found = Int(SecItemCopyMatching(query, &result))
            if found == Int(errSecSuccess){
                
                let update = [kSecValueData as NSString: newData ,
                              kSecAttrComment as NSString : "my comments"] as NSDictionary
                
                let updated = Int(SecItemUpdate(query, update))
                if updated == Int(errSecSuccess){
                    print("Successfully updated the existing value")
                    readExistingValue();
                } else {
                    print("failed to update the value. error = \(updated)")
                }
            }else{
                print("error happened. Code=\(found)")
            }
        }
        catch {
            print(error)
        }
        
    }
    
    /// 删除钥匙串
    /// - Parameter keyToSearchFor: key
    func deleteKeychian(keyToSearchFor:String){
        let service = Bundle.main.bundleIdentifier
        
        let query = [kSecClass as NSString: kSecClassGenericPassword as NSString,
                     kSecAttrService as NSString: service as Any,
                     kSecAttrAccount as NSString: keyToSearchFor] as NSDictionary
        
        let found = Int(SecItemDelete(query))
        if found == Int(errSecSuccess){
            print("钥匙串删除成功")
        }
        
    }
    //更新多个值
    func readExistingValue() {
        
    }
}
