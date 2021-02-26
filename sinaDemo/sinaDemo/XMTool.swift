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
