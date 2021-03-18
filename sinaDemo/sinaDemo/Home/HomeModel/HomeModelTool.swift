//
//  HomeModelTool.swift
//  sinaDemo
//
//  Created by admin on 2021/3/7.
//
/*
 * 对HomeModel的封装📦
 */
import UIKit
import HandyJSON
class HomeModelTool: NSObject,HandyJSON {
    required override init() {
        
    }
    
    var homeModel:HomeModel?
    var courceText:String?
    var creatAtText:String?
    var picUrls:[String] = []
    
    init(homeModel:HomeModel){
        self.homeModel = homeModel
        //来源
        if let source = homeModel.source, homeModel.source != "" {
            
            let startIndex = source.range(of: "\">")
            let endIndex = source.range(of: "</a>")
            if let startIndex = startIndex,let endIndex = endIndex {
                courceText = String(source[startIndex.upperBound..<endIndex.lowerBound])
            }
        }
        //创建时间
        if let greatTime = homeModel.created_at,homeModel.created_at != "" {
            creatAtText = CreatDateTool.GetDate(crateAtStr: greatTime)
        }
        
        if let picurls = homeModel.pic_urls,picurls.count > 0 {
            
            for picurlDic in picurls {
                picUrls.append(picurlDic["thumbnail_pic"] ?? "")
            }
            
        }else {
            if let picurls = homeModel.retweeted_status?.pic_urls {
                
                for picurlDic in picurls {
                    picUrls.append(picurlDic["thumbnail_pic"] ?? "")
                }
                
            }
        }
        
    }
    
}
