//
//  HomeTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
// 

import UIKit
import AutoInch
import YYModel
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
            //注册cell
            tableView?.register(UINib.init(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCellId")
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 200
        }
       
//        let param = ["name":"213"]
//        XMNetWorkTool.shareNetworkTool.requestWithNetworkTool(methd: .POST, url: "https://httpbin.org/post", params: param, headers: nil) { (error, reponse) in
//            print(reponse as Any)
//        }
        
        
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
        //下面两个有点区别，第一个自定义的是button，可以设置高亮image
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "navigationbar_friendsearch")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendsearch"), style: .done, target: self, action: #selector(self.friendClick))
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
        
        //self.separatorInset = UIEdgeInsets.zero
        //self.view.layoutMargins = UIEdgeInsets.zero
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
    @objc func zhuanfaClick(){
        XMLog("zhuanfaClick")
    }
}
// MARK: - 代理方法

extension HomeTableCtr{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellId") as? HomeCell
        if cell == nil {
            cell = HomeCell.init(style: .default, reuseIdentifier: "HomeCellId")
        }
//        cell!.zhuanfa.addTarget(self, action: #selector(self.zhuanfaClick), for: .touchUpInside)
        return cell!
    }
}
