//
//  XMTextView.swift
//  sinaDemo
//
//  Created by admin on 2021/3/14.
//

import UIKit

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
//        self.delegate = self
        self.textContainerInset = UIEdgeInsets.init(top: 8, left: 4, bottom: 10, right: 8)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            placeHoldLb.text = ""
        }else{
            placeHoldLb.text = placeHoldText
        }
    }
}
