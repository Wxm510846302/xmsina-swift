//
//  EmotionPakageManager.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/22.
//

import UIKit

class EmotionPakageManager: NSObject {
    var packages:[EmotionPackage] = [EmotionPackage]()
    override init() {
        packages.append(EmotionPackage.init(""))
        packages.append(EmotionPackage.init("default"))
        packages.append(EmotionPackage.init("emoji"))
        packages.append(EmotionPackage.init("lxh"))
    }
}
class EmotionPackage {
    
    var emoticons:[Emoticon] = [Emoticon]()
    init(_ pakageCode:String) {
        if pakageCode.count > 0 {
            let pakagePath = Bundle.main.path(forResource:"EmotionIconResource", ofType:"bundle")
            let pakageBundle = Bundle.init(path: pakagePath!)
            let plistPath = pakageBundle!.path(forResource: "info", ofType: "plist",inDirectory: pakageCode)
            let plistArray = NSArray(contentsOfFile: plistPath!) as! [[String:String]]
            for var item in plistArray {
                if let png = item["png"] {
                    item["png"] = pakagePath!  + "/\(pakageCode)/" + png
                }
                emoticons.append(Emoticon.init(dic: item))
            }
//            print(emoticons)
        }
    }
}

@objcMembers
class Emoticon : NSObject{
    var chs:String = ""
    var png:String = "" {
        didSet {
            path = png
        }
    }
    var path:String = ""
    var gif:String = ""
    var code:String = ""{
        didSet {
            //第一步: 创建一个 Scanner 的实例对象
            let scan = Scanner(string: code)
            //第二步: 定义一个可变的 UInt32 类型的变量用于接收
            var result: UInt32 = 0
            scan.scanHexInt32(&result)
            //第三步: -> 转换成一个Unicode
            guard let unicode = UnicodeScalar(result) else { return }
            //第四步: 把 unicode转换成 Character
            let character = Character(unicode)
            code = "\(character)"
        }
    }
    
    init(dic:[String:String]) {
        super.init()
        setValuesForKeys(dic)
    }
    override  func setValue(_ value: Any?, forUndefinedKey key: String) {
//        print(key)
    }
    override class func description() -> String {
        return ["chs","path","code"].description
    }
}
