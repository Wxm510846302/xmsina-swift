//
//  XMTool.swift
//  sinaDemo
//
//  Created by admin on 2021/2/26.
//

import Foundation
import UIKit
import CommonCrypto
func XMLog<T>(msg:T, file :String = #file ,funcName:String = #function ,lineNum:Int = #line )  {
    #if DEBUG
    let ext = (file as NSString).lastPathComponent
    print("XMLOG-file:\(ext) Func:[\(funcName)] Line:\(lineNum) msg:\(msg)")
    #endif
}
extension UIColor {
    
    /// 16进制转color
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

extension String {
    //    如果需要小写，将"%02X"改成"%02x"
    var MD5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        //        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        //        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

/// 归档manager
class XMFileManager: NSObject {
    
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
    func getArchiver(fileName:String) -> Any {
        // 路径
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 拼接路径 自动带斜杠的
        let filePath = (file as NSString).appendingPathComponent( fileName + ".archiver")
        do {
            let data = try Data.init(contentsOf: URL(fileURLWithPath: filePath))
            // 当用户首次登陆, 直接从沙盒获取数据, 就会为nil  所以这里需要使用as?
            let model:Any = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) ?? "没有东西"
            return model
        } catch {
            print("获取data数据失败: \(error)")
        }
        return "获取data数据失败"
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
                     
                     kSecReturnAttributes as NSString : kCFBooleanTrue!,
                     
                     kSecReturnData as NSString : kCFBooleanTrue!
                     
        ] as NSDictionary
        
        var valueAttributes : CFTypeRef?
        
        let results = Int(SecItemCopyMatching(query, &valueAttributes))
        
        if results == Int(errSecSuccess) {
            
            let attributes = valueAttributes! as! NSDictionary
            
//            let key = attributes[kSecAttrAccount as NSString] as! String
//
//            let accessGroup = attributes[kSecAttrAccessGroup as NSString] as! String
//
//            let createDate = attributes[kSecAttrCreationDate as NSString] as! NSDate
//
//            let modifiedDate = attributes[kSecAttrModificationDate as NSString] as! NSDate
//
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
    func queryDataFromKeyChain(keyToSearchfor:String) -> Any{
        
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
                return ret ?? "try NSKeyedUnarchiver file"
            } catch  {
                return "钥匙串查询失败"
            }
        }else{
            print("Error happened with code:\(results)")
        }
        return "钥匙串查询失败"
        
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
    //    func getKeychainQuery(keyToSearchFor:String) -> NSDictionary {
    //        <#function body#>
    //    }
    
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

