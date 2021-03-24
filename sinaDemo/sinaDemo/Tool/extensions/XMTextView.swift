//
//  XMTextView.swift
//  sinaDemo
//
//  Created by admin on 2021/3/14.
//

import UIKit
class XMAttachment: NSTextAttachment {
    var chs:String?
}
class XMTextView: UITextView,UITextViewDelegate {
    var placeHoldText = "分享点什么吧"
    override var text: String! {
        didSet {
            if self.placeHoldLb.text?.count ?? 0 > 0 {
                placeHoldLb.text = ""
            }else{
                placeHoldLb.text = placeHoldText
            }
            
        }
    }
    lazy  var placeHoldLb = UILabel.init().then {
        $0.frame = CGRect.init(x: 10, y: 0, width: 150, height: 32)
        self.addSubview($0)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        placeHoldLb.text = placeHoldText
        placeHoldLb.font = UIFont.systemFont(ofSize: 14)
        placeHoldLb.textColor = .gray
        self.textContainerInset = UIEdgeInsets.init(top: 8, left: 4, bottom: 10, right: 8)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            placeHoldLb.text = ""
        }else{
            placeHoldLb.text = placeHoldText
        }
    }
    
    //插入表情符
    func insertEmotionText(emoticon:Emoticon) {
        //获取光标位置
        let uirange = self.selectedTextRange!
        let nsrange = self.selectedRange
        if emoticon.code.count > 0 && emoticon.code != "\0" {
            //emoji
            self.replace(uirange, withText: emoticon.code)
        }
        else if emoticon.path.count > 0 {
            //插入普通表情
            let attachMent = XMAttachment()
            attachMent.chs = emoticon.chs
            attachMent.image = UIImage(contentsOfFile: emoticon.path)
            let font = self.font!
            attachMent.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachMent)
            
            let attrMStr = NSMutableAttributedString(attributedString: self.attributedText)
            attrMStr.replaceCharacters(in: nsrange, with: attrImageStr)

            self.attributedText = attrMStr
            //恢复字体大小和当前位置
            self.font = font
            self.selectedRange = NSRange(location: nsrange.location + 1, length: 0)
        }
        if self.placeHoldLb.text?.count ?? 0 > 0 {
            self.placeHoldLb.text = ""
        }
        
    }
    //获取包含表情符的字符串
    func getAttributeString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString:self.attributedText)
        let range = NSRange(location: 0, length:attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let att = dict[NSAttributedString.Key(rawValue: "NSAttachment")] as? XMAttachment{
                attrMStr.replaceCharacters(in: range, with: att.chs!)
            }
        }
        return attrMStr.string
    }
}
