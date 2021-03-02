//
//  PopPresentationCtr.swift
//  sinaDemo
//
//  Created by Ela on 2021/3/2.
//

import UIKit

class PopPresentationCtr: UIPresentationController {
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = CGRect(x: 100, y: 100, width: 180, height: 250)
    }
}
