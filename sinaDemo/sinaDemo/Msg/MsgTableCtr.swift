//
//  MsgTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
//

import UIKit

class MsgTableCtr: XMBaseTableCtr {
    
    ///弹出视图遵循代理的自定义class
    lazy var PopPresentDelegate:PopTransitioning = PopTransitioning.init { [weak self](presened) in
        //hom强引用了 PopPresentDelegate，PopPresentDelegate又强引用了闭包，闭包里面又有PopPresentDelegate，需要打破循环引用
        self?.titleView.isSelected = presened
    }
    
    lazy var titleView:XMRightImgBtn = XMRightImgBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isLogin {
            setUpNavgationBar()
        }else{
            visitorView.setupVistorUI(backImg: "tabbar_message_center", msg: "消息访客视图")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
extension MsgTableCtr {
    private func setUpNavgationBar(){
        titleView.setTitle("wxm", for: .normal)
        titleView.addTarget(self, action: #selector(self.titleViewClick), for: .touchUpInside)
        navigationItem.titleView = titleView
    }
}
// MARK: - 点击事件

extension MsgTableCtr{
    
    /// 弹出选择框ctr
    @objc func titleViewClick() {
        self.titleView.isSelected = !self.titleView.isSelected
        let poVc = PopViewCtr.init()
        //设置选择框的弹出代理为 PopPresentDelegate
        poVc.transitioningDelegate = PopPresentDelegate
        poVc.modalPresentationStyle = .custom
        self.present(poVc, animated: true, completion: nil)
    }
}
