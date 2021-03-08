//
//  Then.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/2.
//

import Foundation
import CoreGraphics
#if os(iOS) || os(tvOS)
   import UIKit.UIGeometry
#endif
protocol ValueDelegate {
    
    var floatValue:CGFloat { get }
    
}

extension Double:ValueDelegate{
    var intValue: Int {
        get{
            return Int(self)
        }
    }
    
    var floatValue: CGFloat {
        get {
           return  CGFloat(self)
        }
    }
}

extension Int:ValueDelegate{

    var floatValue: CGFloat {
        get {
           return  CGFloat(self)
        }
    }
}

//声明一个协议叫Then
public protocol Then{}

//都有谁来遵循这个Then协议
extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Then {}
  extension UIOffset: Then {}
  extension UIRectEdge: Then {}
#endif

/// 当前的Self是Any类型的，它遵循 Then协议的拓展func with 和 do 并且将其实现：|| *self-实现了Then协议的拓展func with 和 do方法* ||（Then协议在哪拓展呢？在Any类型实例化的“Self"中 ）
extension Then where Self : Any {
    
    /// Makes it available to set properties with closures just after initializing and copying the value types.
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    public func with(_ block:(inout Self) throws ->Void) rethrows -> Self{
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do`(_ block: (Self) throws -> Void) rethrows {
      try block(self)
    }
}

extension Then where Self: AnyObject {

  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///       $0.textAlignment = .Center
  ///       $0.textColor = UIColor.blackColor()
  ///       $0.text = "Hello, World!"
  ///     }
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }

}


