//
//  EmotionPakageManager.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/22.
//

import UIKit
import HandyJSON
class EmotionPakageManager: NSObject,HandyJSON {
    static let shareManager:EmotionPakageManager = EmotionPakageManager.init()
    var packages:[EmotionPackage] = [EmotionPackage]()
    var PackageMap:[String:String] = [String:String]()
    internal required override init() {
        packages.append(EmotionPackage.init(""))
        packages.append(EmotionPackage.init("default"))
        packages.append(EmotionPackage.init("emoji"))
        packages.append(EmotionPackage.init("lxh"))
        for package in packages[1...3] {
            for emotion in package.emoticons {
                PackageMap.updateValue(emotion.path , forKey: emotion.chs)
            }
        }
    }
}
class EmotionPackage :HandyJSON,NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(emoticons,forKey:"emoticons")
    }
    required init?(coder: NSCoder) {
        self.emoticons = coder.decodeObject(forKey: "emoticons") as! [Emoticon] 
    }
    required init() {
    }
    var emoticons:[Emoticon] = [Emoticon]()
    init(_ pakageCode:String) {
        if pakageCode.count > 0 {
            let pakagePath = Bundle.main.path(forResource:"EmotionIconResource", ofType:"bundle")
            let pakageBundle = Bundle.init(path: pakagePath!)
            let plistPath = pakageBundle!.path(forResource: "info", ofType: "plist",inDirectory: pakageCode)
            let plistArray = NSArray(contentsOfFile: plistPath!) as! [[String:String]]
            for var item in plistArray {
                if let png = item["png"] {
                    item["path"] = pakagePath!  + "/\(pakageCode)/" + png
                }
                emoticons.append(Emoticon.init(dic: item))
            }
        }else {
            guard let recentlyEmotionPackage:[Emoticon] = XMFileManager.init().getArchiver(fileName: RecentlyEmotionString) as? [Emoticon] else {
                return
            }
            guard let pakagePath = Bundle.main.path(forResource:"EmotionIconResource", ofType:"bundle") else { return  }
            for emotion in recentlyEmotionPackage {
                if emotion.path.count > 0 {
                    let subpath = pakagePath + emotion.path
                    emotion.path = subpath
                }
                else{
                    emotion.code = emotion.originCode
                }
                emoticons.append(emotion)
            }
         
        }
    }
}

@objcMembers
class Emoticon : NSObject,HandyJSON,NSMutableCopying,NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    func encode(with coder: NSCoder) {
        coder.encode(chs,forKey:"chs")
        coder.encode(path,forKey:"path")
        coder.encode(gif,forKey:"gif")
        coder.encode(png,forKey:"png")
        coder.encode(code,forKey:"code")
        coder.encode(originCode,forKey:"originCode")
    }
    
    required init?(coder: NSCoder) {
        self.chs = coder.decodeObject(forKey: "chs") as! String
        self.path = coder.decodeObject(forKey: "path") as! String
        self.gif = coder.decodeObject(forKey: "gif") as! String
        self.png = coder.decodeObject(forKey: "png") as! String
        self.code = coder.decodeObject(forKey: "code") as! String
        self.originCode = coder.decodeObject(forKey: "originCode") as! String
    }
    
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        let emoticon = Emoticon.init()
        emoticon.chs = self.chs
        emoticon.path = self.path
        emoticon.gif = self.gif
        emoticon.png = self.png
        emoticon.code = self.code
        emoticon.originCode = self.originCode
        return emoticon
    }
    required override init() {
        
    }
    var chs:String = ""
    var png:String = ""
    var path:String = ""
    var gif:String = ""
    var originCode = ""
    var code:String = ""{
        didSet {
            originCode = code
            //?????????: ???????????? Scanner ???????????????
            let scan = Scanner(string: code)
            //?????????: ????????????????????? UInt32 ???????????????????????????
            var result: UInt32 = 0
            scan.scanHexInt32(&result)
            //?????????: -> ???????????????Unicode
            guard let unicode = UnicodeScalar(result) else { return }
            //?????????: ??? unicode????????? Character
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
