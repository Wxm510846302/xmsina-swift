//
//  PopPresentationCtr.swift
//  sinaDemo
//
//  Created by Ela on 2021/3/2.
//

import UIKit
///弹出presentviewctr的容器ctr
class PopPresentationCtr: UIPresentationController {
    //设置蒙版
    lazy var back:UIView = UIView.init().then{
        $0.frame = containerView!.bounds
        $0.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        let tip = UITapGestureRecognizer.init(target: self, action: #selector(self.tipClick))
        $0.addGestureRecognizer(tip)
    }
    //重写容器的WillLayoutSubviews
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //设置弹出view的大小
        presentedView?.frame = CGRect(x: kScreenWidth/2-90.auto(), y: kNavigationHeight+5.auto(), width: 180.auto(), height: 250.auto())
        //添加蒙版
        containerView!.addSubview(self.back)
    }
    //蒙版点击事件
    @objc func tipClick() {
        XMLog("tipClick")
        //弹出视图控制器dismiss
        presentedViewController.dismiss(animated: true) {
            
        }
    }
}
