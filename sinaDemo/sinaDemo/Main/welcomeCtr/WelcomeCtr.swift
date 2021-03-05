//
//  WelcomeCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/5.
//

import UIKit

class WelcomeCtr: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startWelcomeAnimation()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.iconImg.frame.size = CGSize.init(width: 100.auto(), height: 100.auto())
        self.iconImg.layer.cornerRadius = self.iconImg.frame.size.width/2
        self.iconImg.layer.masksToBounds = true
    }
    func startWelcomeAnimation(){
        
//        iconImg.frame.size = CGSize.init(width: 100.auto(), height: 100.auto())
//        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 8, options: []) {
//            self.iconImg.frame.origin.y =  100.auto()
//            self.label.frame.origin.y = self.iconImg.frame.origin.y+self.iconImg.frame.size.height+8.auto()
//        } completion: { (success) in
//            if success{
////                if #available(iOS 13.0, *) {
////                    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
////                } else {
////                    // Fallback on earlier versions
////                    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
////                }
//            }
//        }
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
