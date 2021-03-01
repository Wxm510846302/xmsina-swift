//
//  XMTabBarCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
//  111

import UIKit

class XMTabBarCtr: UITabBarController {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        XMLog("didSelect")
    }
    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        XMLog("willBeginCustomizing")
    }
    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
        XMLog("didBeginCustomizing")
    }
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        XMLog("didEndCustomizing")
    }
    override func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {
        XMLog("willEndCustomizing")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 这样可以根据后台来动态加载tabbar
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else { return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        guard let anyObj = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) else {
            return
        }
        guard anyObj is [[String:String]]  else {
            return
        }
        let anyArray = anyObj as! [[String:String]]
        
        for item in anyArray {
            guard let vcName = item["vcName"]  else {
                continue
            }
            guard let title = item["title"]  else {
                continue
            }
            guard let normalImg = item["normalImg"]  else {
                continue
            }
            guard let selectedImg = item["selectedImg"]  else {
                continue
            }
            addChild(childVc: vcName, name: title, normalImg: normalImg, selectedImg: selectedImg)
        }
//        self.tabBar.items?[0].badgeValue = "3"
//        self.tabBarItem.badgeValue = "2"
    }
    
    private func addChild(childVc: String, name:String, normalImg:String,selectedImg:String) {
        guard let nameSpace = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String else {
            XMLog("没有获取命名空间")
            return
        }
        guard let childvc = NSClassFromString(nameSpace + "." + childVc) else {
            XMLog("没有获取字符串对应到class")
            return
        }
        guard let childvctype = childvc as? UIViewController.Type else {
            XMLog("没有获取对应到控制器类型")
            return
        }
        let ctr: UIViewController = childvctype.init()
        ctr.tabBarItem.selectedImage = UIImage(named: selectedImg)
        ctr.tabBarItem.image = UIImage(named: normalImg)
       
//        childVc.tabBarItem.title = name
        ctr.title = name
        let navCtr = UINavigationController.init(rootViewController: ctr)
        navCtr.title = name
        self.addChild(navCtr)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
