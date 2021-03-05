//
//  XMNetWorkTool.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
import AFNetworking

typealias callBack = (Error?,Any?)->Void

enum NetworkMethdType {
    case GET
    case POST
    case DOWNLOAD
    case UPLOAD
}
class XMNetWorkTool: AFHTTPSessionManager {
 
    static let shareNetworkTool = XMNetWorkTool.init().then {
        $0.responseSerializer.acceptableContentTypes =  Set(arrayLiteral: "application/json",
                                                           "text/json",
                                                           "text/javascript",
                                                           "text/html",
                                                           "text/plain",
                                                           "application/x-www-form-urlencodem")
    }
}
// MARK: - 封装基础请求方法

extension XMNetWorkTool {
    
   public func requestWithNetworkTool(methd:NetworkMethdType,url:String,params:[String:Any]?,headers:[String:String]?,finishBlock:@escaping (Error?,Any?)->Void) {
    // FIXME: - 这里应该有个判断，token是否过期，如果在使用过程中过期了怎么办？应该重新获取一下token
        let successFinish = { (task:URLSessionDataTask, response:Any?) in
            finishBlock(nil,response)
        }
        let failureFinish = { (task:URLSessionDataTask?, error:Error) in
            finishBlock(error,nil)
        }
        
        switch methd {
        
        case .GET:
            
            get(url, parameters: params, headers: headers, progress: nil, success: successFinish, failure: failureFinish)
            
            break
        case .POST:
            
            post(url, parameters: params, headers: headers, progress: nil, success: successFinish, failure: failureFinish)
            
            break
        default: break
            
        }
    }
    
    // FIXME: - 这里需要再进行封装

    func requestWithNetworkTool(methd:NetworkMethdType,url:String,uploadData:Data?, progress:((Progress)->Void)?,finishBlock:@escaping (Error?,[String:AnyObject]?)->())  {
        
        let successFinish = { (response:URLResponse, any:Any?, error:Error?) in
            
        }
  
        switch methd {
        
    
        case .DOWNLOAD:
            
            guard let URLK = URL.init(string: url) else {
                return
            }
            
            let request = URLRequest(url: URLK)
            downloadTask(with: request, progress: progress, destination: { (url:URL, response:URLResponse) -> URL in
                return URL.init(string: "")!
            }, completionHandler: successFinish).resume()

            break
            
        case .UPLOAD:
            guard let URLK = URL.init(string: url) else {
                return
            }
            
            let request = URLRequest(url: URLK)
            uploadTask(with: request, from: uploadData, progress: progress, completionHandler: successFinish)
            break
            
        default:break
            
        }
    }
}

extension XMNetWorkTool{
    // MARK: - 获取token
    func getAccessToken(params:[String:Any]?,finish:@escaping callBack) {
        self.requestWithNetworkTool(methd: .POST, url: access_tokenUrl, params: params, headers: nil, finishBlock: finish)
    }
    // MARK: - 获取用户信息

    func getUserInfo(params:[String:Any]?,finish:@escaping callBack) {
        self.requestWithNetworkTool(methd: .GET, url: usersShowUrl, params: params, headers: nil, finishBlock: finish)
    }
}
