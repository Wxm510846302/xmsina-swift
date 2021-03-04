//
//  PopTransitioning.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/2.
//

import UIKit

/// 弹出视图遵循代理的自定义class
class PopTransitioning: NSObject{
    var callBack:((Bool)->Void)? = nil
    var isPresened :Bool = false
    init(callback:@escaping ((Bool)->Void)){
        self.callBack = callback
    }
}
extension PopTransitioning:UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    /// 弹出和消失动画的时间
    /// - Parameter transitionContext: 上下文
    /// - Returns: 秒
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /// 转场上下文，可以获取弹出和消失的view
    ///UITransitionContextFromViewKey, and UITransitionContextToViewKey
    /// - Parameter transitionContext: 上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //获取弹出的view
        if self.isPresened {
            guard let presenedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return  }
            transitionContext.containerView.addSubview(presenedView)
            //添加动画,先变小
            presenedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            presenedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
//            presenedView.frame.size.height = 0
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
//                presenedView.frame.size.height = 250.auto()
                presenedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: {
                if $0 {
                    transitionContext.completeTransition(true)
                }
            }
        }else {
            guard let presenedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return  }
            transitionContext.containerView.addSubview(presenedView)
            //添加动画
//            presenedView.frame.size.height = 250.auto()
            presenedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            presenedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
//                presenedView.frame.size.height = 0.001
                presenedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
            } completion: {
                if $0 {
                    transitionContext.completeTransition(true)
                }
            }
        }
       

    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopPresentationCtr(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresened = true
        self.callBack?(self.isPresened)
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresened = false
        self.callBack?(self.isPresened)
        return self
    }
}
