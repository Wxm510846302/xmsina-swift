//
//  UIBarItemExtension.swift
//  sinaDemo
//
//  Created by Ela on 2021/3/2.
//

import Foundation
import UIKit
extension UIBarButtonItem{
    convenience init(image:String){
        self.init()
        let barButton = UIButton.init()
        barButton.setImage(UIImage(named: image), for: .normal)
        barButton.setImage(UIImage(named: image + "_highlighted"), for: .highlighted)
        barButton.sizeToFit()
        self.customView = barButton
    }
}
