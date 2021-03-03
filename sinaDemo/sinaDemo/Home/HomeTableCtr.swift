//
//  HomeTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
// 

import UIKit
import AutoInch
class HomeTableCtr: XMBaseTableCtr {
    
    lazy var PopPresentDelegate:PopTransitioning = PopTransitioning.init { [weak self](presened) in
        //hom强引用了 PopPresentDelegate，PopPresentDelegate又强引用了闭包，闭包里面又有PopPresentDelegate，需要打破循环引用
        self?.titleView.isSelected = presened
    }
    
    lazy var titleView:XMRightImgBtn = XMRightImgBtn()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.badgeValue = "3"
        
        if !self.isLogin {
            //如果没有登录，那么就创建访客视图
            self.visitorView.setupVistorUI(backImg: "tabbar_home", msg: "首页访客视图")
        }else{
            setUpNavgationItems()
        }
        
      
        
//        print(
//            "this is " +
//                "default".screen
//                .width(._320, is: "宽度 320")
//                .width(._375, is: "宽度 375")
//                .height(._844, is: "高度 844")
//                .height(._812, is: "高度 812")
//                .inch(._4_7, is: "4.7 英寸")
//                .inch(._5_8, is: "5.8 英寸")
//                .inch(._6_5, is: "6.5 英寸")
//                .level(.compact, is: "屏幕级别 紧凑屏")
//                .level(.regular, is: "屏幕级别 常规屏")
//                .level(.full, is: "屏幕级别 全面屏")
//                .value
//        )
//        print(0.screen.level(.full, is: 1).inch(._6_1, is: 2).level(.compact, is: 0).value)
//        print("当前屏幕级别: \(Screen.Level.current)")
//        print("是否为全面屏: \(Screen.isFull)")
        
    }


}
// MARK: - 设置UI

extension HomeTableCtr {
    //设置导航条
    func setUpNavgationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: "navigationbar_pop"),UIBarButtonItem(image: "navigationbar_redbag")]
        titleView.setTitle("wxm", for: .normal)
        titleView.addTarget(self, action: #selector(self.titleViewClick), for: .touchUpInside)
        navigationItem.titleView = titleView
        let friend = navigationItem.leftBarButtonItems?.first?.customView as? UIButton
        let pop = navigationItem.rightBarButtonItems?.first?.customView as? UIButton
        let redbag = navigationItem.rightBarButtonItems?.last?.customView as? UIButton
        pop?.addTarget(self, action: #selector(self.popClick), for: .touchUpInside)
        redbag?.addTarget(self, action: #selector(self.redbagClick), for: .touchUpInside)
        friend?.addTarget(self, action: #selector(self.friendClick), for: .touchUpInside)
    }
   
}
// MARK: - 监听点击事件

extension HomeTableCtr{
    //弹出选择框ctr
    @objc func titleViewClick() {
        self.titleView.isSelected = !self.titleView.isSelected
        let poVc = PopViewCtr.init()
        //设置选择框的弹出代理为 PopPresentDelegate
        poVc.transitioningDelegate = PopPresentDelegate
        poVc.modalPresentationStyle = .custom
        self.present(poVc, animated: true, completion: nil)
    }
    @objc func popClick(){
        XMLog("popClick")
    }
    @objc func redbagClick(){
        XMLog("redbagClick")
    }
    @objc func friendClick(){
        XMLog("friendClick")
    }
}
