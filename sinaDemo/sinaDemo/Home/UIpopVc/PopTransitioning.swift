//
//  PopTransitioning.swift
//  sinaDemo
//
//  Created by Ela on 2021/3/2.
//

import UIKit

class PopTransitioning: NSObject, UIViewControllerTransitioningDelegate{
    var callBack:((Bool)->Void)? = nil
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopPresentationCtr(presentedViewController: presented, presenting: presenting)
    }
}
