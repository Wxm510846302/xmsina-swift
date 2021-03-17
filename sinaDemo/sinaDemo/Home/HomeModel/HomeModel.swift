//
//  HomeModel.swift
//  sinaDemo
//
//  Created by admin on 2021/3/7.
//

import UIKit
import HandyJSON
@objcMembers
class HomeModel: HandyJSON{
    //用户信息
    var user:UserCount?
    //字符串型的微博ID
    var idstr:String?
    //微博MID
    var mid:Int?
    //微博信息内容
    var text:String?
    //微博创建时间
    var created_at:String?
    //微博来源
    var source:String?
    //转发
    var retweeted_status:HomeModel?
    //图片
    var pic_urls:Array<[String:String]>?
    //转发数
    var reposts_count:Int?
    //评论数
    var comments_count:Int?
    //表态数
    var attitudes_count:Int?
    
    required init() {
    }
}
