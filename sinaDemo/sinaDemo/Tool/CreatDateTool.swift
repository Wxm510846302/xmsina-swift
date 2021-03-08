//
//  CreatDateTool.swift
//  sinaDemo
//
//  Created by admin on 2021/3/6.
//
/*
 *时间转换工具
 */
import UIKit

class CreatDateTool: NSObject {

    override init() {
        super.init()
    }
    static func GetDate(crateAtStr: String) -> String{
//        crateAtStr = "Fri Mar 04 11:16:29 +0800 2021"
     
        //创建时间格式化对象
        let famate = DateFormatter()
        famate.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        famate.locale = NSLocale(localeIdentifier: "en") as Locale
        
        guard let creatDate = famate.date(from: crateAtStr) else {
            return ""
        }
        print(creatDate)
        //获取时间差
        let comp = Int(Date().timeIntervalSince(creatDate))
        print(comp)
        if comp < 60 {
            print("刚刚")
            return "刚刚"
        }
        
        if comp < 60 * 60 {
            print("\(comp / 60) 分钟前")
            return "\(comp / 60) 分钟前"
        }
        if comp < 60 * 60 * 24 {
            print("\(comp / 60 / 60) 小时前")
            return "\(comp / 60 / 60) 小时前"
        }
        
        //是否在昨天
        let calender = NSCalendar.current
        
        if calender.isDateInYesterday(creatDate) {
            famate.dateFormat = "昨天 HH:mm"
            let timeStr = famate.string(from: creatDate)
            print(timeStr)
            return timeStr
        }
        //一年以内
        let comps = calender.dateComponents([.year,.month,.day], from: creatDate, to: Date())

        if comps.year ?? 0 >= 1{
            famate.dateFormat = "yyyy-MM-dd HH:mm"
            let timeStr = famate.string(from: creatDate)
            print(timeStr)
            return timeStr
        }else{
            
            famate.dateFormat = "MM-dd HH:mm"
            let timeStr = famate.string(from: creatDate)
            print(timeStr)
            return timeStr
        }
    }
}
