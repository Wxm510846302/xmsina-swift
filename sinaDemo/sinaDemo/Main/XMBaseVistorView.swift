//
//  XMBaseVistorView.swift
//  sinaDemo
//
//  Created by admin on 2021/3/1.
//

import UIKit

class XMBaseVistorView: UIView {

    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var contentMsgLb: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static func visitorView() -> XMBaseVistorView{
      return  Bundle.main.loadNibNamed("XMBaseVistorView", owner: nil, options: nil)!.first as!XMBaseVistorView
    }
    func setupVistorUI(backImg:String,msg:String) {
        self.backImg.image = UIImage(named: backImg)
        self.contentMsgLb.text = msg
    }
}
