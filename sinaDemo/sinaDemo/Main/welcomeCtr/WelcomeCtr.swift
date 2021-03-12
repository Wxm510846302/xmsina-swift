//
//  WelcomeCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/5.
//

import UIKit
import SDWebImage
class emitterLaterAnimation: NSObject {
    
    var emitter = CAEmitterLayer()
    var giftBtn = UIButton()
    func showEfeectAnimation()  {
        let firworksLayer = CAEmitterLayer.init(layer: self.giftBtn.layer)
        firworksLayer.zPosition = 0
        UIApplication.shared.keyWindow?.layer.addSublayer(firworksLayer)
        emitter = firworksLayer
        firworksLayer.emitterPosition = CGPoint(x: self.giftBtn.frame.origin.x + self.giftBtn.frame.size.width/2, y:kScreenHeight - 150.auto() )
        firworksLayer.emitterSize = CGSize(width: 5, height: 3)  // 宽度为一半
        firworksLayer.emitterMode = CAEmitterLayerEmitterMode.outline;
        firworksLayer.emitterShape = CAEmitterLayerEmitterShape.line;
        firworksLayer.renderMode = CAEmitterLayerRenderMode.additive;
        var cells:Array<CAEmitterCell>?
        
        let imgStr = ["xingxing2","xingxing3","xingxing4","xingxing5","xingxing6","xingxing7","xingxing8","xingxing9","xingxing6","yuan","yuan2","yuan3","yuan4","yuan5"]
        for item in imgStr {
                 _ = CAEmitterCell.init().then { (sparkCell) in
                sparkCell.name = "sparkCell";
                sparkCell.birthRate = 2.5;
                sparkCell.lifetime = 0.9;
                sparkCell.velocity = 70.0;
                sparkCell.yAcceleration = 30.0;  // 模拟重力影响
                sparkCell.emissionRange = CGFloat(Double.pi * 0.7);  // 360度
                sparkCell.scale = 0.4;
                sparkCell.contents = UIImage(named: item)?.cgImage
                sparkCell.redSpeed = 0.4;
                sparkCell.greenSpeed = -0.1;
                sparkCell.blueSpeed = -0.1;
                sparkCell.alphaSpeed = -0.4;
                sparkCell.spin = CGFloat(Double.pi * 2); // 自转
                cells?.append(sparkCell)
            }
        }
        firworksLayer.emitterCells = cells
    }
}
class WelcomeCtr: UIViewController {
    
    @IBOutlet weak var iconBottom: NSLayoutConstraint!
    
    @IBOutlet weak var iconImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.iconImg.sd_setImage(with:URL(string:  UserCountManager.userModel?.avatar_large ?? ""), placeholderImage: UIImage(named: "avatar_default_big"), options: [], context: nil)
        self.iconImg.sd_setImage(with: URL(string:  UserCountManager.userModel?.avatar_large ?? "")) { (img, error, type, url) in
            self.startWelcomeAnimation()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.iconImg.frame.size = CGSize.init(width: 100, height: 100)
        self.iconImg.layer.cornerRadius = 50
        self.iconImg.layer.masksToBounds = true
          
    }
    func startWelcomeAnimation(){
        // FIXME: - 登录有点问题

        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: []) {

            self.iconImg.frame.origin.y =  100
            self.iconBottom.constant = kScreenHeight - 200
            self.iconImg.layoutIfNeeded()

        } completion: { (success) in
            if success{
                if #available(iOS 13.0, *) {
                    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
                }
            }
        }
    }
    
}
