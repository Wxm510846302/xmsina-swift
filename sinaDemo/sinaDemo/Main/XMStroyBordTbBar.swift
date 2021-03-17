//
//  XMStroyBordTbBar.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
//

import UIKit

class XMStroyBordTbBar: UITabBarController {
   
    let composeBtn = UIButton(imgName: "jia", bgImgName: "jia")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpComposeBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
}
// MARK: - 代理方法

extension XMStroyBordTbBar {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            do {
                if self.selectedIndex == 0 {
                    //在当前页面才刷新
                    let homeNav:UINavigationController = self.children.first as! UINavigationController
                    let home:HomeTableCtr = homeNav.children.first as! HomeTableCtr
                    home.TabBarDidClick()
                }
            }
        case 2:
            do {print("点击的是消息")}
        case 3:
            do {print("点击的是发现")}
        case 4:
            do {print("点击的是我的")}
        default:
            do {print("点击的是其他")}
        }
    }
}
extension XMStroyBordTbBar {
//    func chooseVisitorView(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}
extension XMStroyBordTbBar {
    func setUpComposeBtn() {
        for item in 0..<tabBar.items!.count {
            
            if item == 2 {
                
                composeBtn.addTarget(self, action: #selector(self.compose), for: .touchUpInside)
                composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
                tabBar.addSubview(composeBtn)
            }
        }
    }
    @objc private func compose() {
//        composeBtn.isSelected = !composeBtn.isSelected

        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        
        rotationAnim.repeatCount = 1
        rotationAnim.duration = 0.3
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.fillMode = .forwards
//        if composeBtn.isSelected {
            
            rotationAnim.fromValue = 0
            rotationAnim.toValue = CGFloat.pi / 4
            
            // 3.将动画添加到layer中
            composeBtn.layer.add(rotationAnim, forKey: "rote1")
            
//        }
//        else {
//            rotationAnim.fromValue = CGFloat.pi / 4
//            rotationAnim.toValue = 0
//
//            // 3.将动画添加到layer中
//            composeBtn.layer.add(rotationAnim, forKey: "rote1")
//        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
            //弹出控制器
            let composeNav = UINavigationController.init(rootViewController: ComposeCtr.init())
            composeNav.modalPresentationStyle = .fullScreen
            self.present(composeNav, animated: true) {
                rotationAnim.fromValue = CGFloat.pi / 4
                rotationAnim.toValue = 0
                
                // 3.将动画添加到layer中
                self.composeBtn.layer.add(rotationAnim, forKey: "rote1")
            }
        })
        
    }
    
}
