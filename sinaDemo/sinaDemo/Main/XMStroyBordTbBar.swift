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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        composeBtn.isSelected = !composeBtn.isSelected
        XMLog("dianji")
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        
        rotationAnim.repeatCount = 1
        rotationAnim.duration = 0.3
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.fillMode = .forwards
        if composeBtn.isSelected {
            
            rotationAnim.fromValue = 0
            rotationAnim.toValue = CGFloat.pi / 4
            
            // 3.将动画添加到layer中
            composeBtn.layer.add(rotationAnim, forKey: "rote1")
            
        }else {
            rotationAnim.fromValue = CGFloat.pi / 4
            rotationAnim.toValue = 0
            
            // 3.将动画添加到layer中
            composeBtn.layer.add(rotationAnim, forKey: "rote1")
        }
    }
    
}
