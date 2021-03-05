//
//  AppDelegate.swift
//  sinaDemo
//
//  Created by admin on 2021/2/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = .orange
        UINavigationBar.appearance().tintColor = .orange
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                XMLog("授权推送 - \(success ? "成功":"失败")")
            }
        }else
        {
            //ios 10 以下
            let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
            
        }
       
        //        UITabBarItem.appearance().setTitleTextAttributes(
        //            [NSAttributedString.Key.foregroundColor: UIColor.gray], for:.normal)
        //        UITabBarItem.appearance().setTitleTextAttributes(
        //            [NSAttributedString.Key.foregroundColor: UIColor.orange], for:.selected)
        //        UITabBarItem.appearance() .setBadgeTextAttributes([NSAttributedString.Key.font:12], for: .normal);
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        XMLog("configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        XMLog("didDiscardSceneSessions")
    }
    
    
}

