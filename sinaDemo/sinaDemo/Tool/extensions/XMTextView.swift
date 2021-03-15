//
//  XMTextView.swift
//  sinaDemo
//
//  Created by admin on 2021/3/14.
//

import UIKit

class XMTextView: UITextView {
    var placeHoldText = ""
    lazy  var placeHoldLb = UILabel.init()

    init(placeHoldSting:String) {
        super.init(frame: CGRect.zero, textContainer: nil)
        placeHoldText = placeHoldSting
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
