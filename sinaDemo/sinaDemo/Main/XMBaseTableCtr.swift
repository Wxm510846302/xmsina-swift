//
//  XMBaseTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/3/1.
//

import UIKit

class XMBaseTableCtr: UITableViewController {
    //懒加载访客视图
    lazy var visitorView :XMBaseVistorView = XMBaseVistorView.visitorView()
    lazy var LoginBtn : UIButton = UIButton.init()
    //全局登录状态
//    var isLogin:Bool = true
    var isLogin:Bool = UserCountManager.isLogin
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLogin {
            self.tableView.separatorStyle = .none
        }
    }

  
    
}
// MARK: - 设置UI

extension XMBaseTableCtr
{
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    func setupVisitorView()  {
//        LoginBtn.frame.size = CGSize.init(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        self.view = visitorView
        visitorView.loginBtn.addTarget(self, action: #selector(self.loginClick), for: .touchUpInside)
        setNavgationItems()
    }
    //设置导航控制器左右按钮item
    func setNavgationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(self.registClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.loginClick))
    }
    @objc private func loginClick() {
        print("loginClick")
        let AutoCtr = AutoLoginCtr.init()
        let nav = UINavigationController.init(rootViewController: AutoCtr)
        present(nav, animated: true, completion: nil)
    }
    @objc private func registClick() {
        print("registClick")
    }
}
