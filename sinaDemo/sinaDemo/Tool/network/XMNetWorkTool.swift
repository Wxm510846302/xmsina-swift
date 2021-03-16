//
//  XMNetWorkTool.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
import Moya
//let sinaAppKey = "3493872115"
//let sinaAppSecret = "275528b28296a1ce7e35c2e32822e703"
//let sinaRedirectUrl = "http://www.mathjia.com"
let sinaAppKey = "1577705334"
let sinaAppSecret = "0038f4b02f0f326685bc64fe7f06320f"
let sinaRedirectUrl = "http://www.mathjia.com"



let myEndpointClosure = { (target: MyService) -> Endpoint in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )

    //在这里设置你的HTTP头部信息
    return endpoint.adding(newHTTPHeaderFields: [
        "Content-Type" : "application/x-www-form-urlencoded",
        "ECP-COOKIE" : ""
        ])
    
}

let xmProvider = MoyaProvider<MyService>(endpointClosure: myEndpointClosure,plugins:[])

private func endpointMapping<Target: TargetType>(target: Target) -> Endpoint {
    print("请求连接：\(target.baseURL)\(target.path) \n方法：\(target.method)\n参数：\(String(describing: target.task)) ")
    return MoyaProvider.defaultEndpointMapping(for: target)
}


enum MyService {
    case getAccessToken(client_id:String,client_secret:String,grant_type:String,redirect_uri:String,code:String)
    case getUserInfo(access_token:String,uid:String)
    case getHomePageData(access_token:String,since_id:Int,max_id:Int)
}
extension MyService:TargetType{
    var baseURL: URL {
        switch self {
        case .getAccessToken:
            return URL.init(string: "https://api.weibo.com/oauth2/")!
        default:
            return URL.init(string: "https://api.weibo.com/2/")!
        }
        
    }
    var validationType: ValidationType{
        return .none
    }
    var path: String {
        switch self {
        case .getAccessToken:
            return "access_token"
        case .getUserInfo:
            return "users/show.json"
        case .getHomePageData:
            return "statuses/home_timeline.json"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAccessToken:
            return .post
        default:
            return .get
        }
    }
    //这个就是做单元测试模拟的数据，
    //只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }

    // 请求任务事件（这里附带上参数）
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        // MARK: - sina 这里是个坑，虽然写的是 post'提交 但是这里的post的写法应该是表单为空，url拼接上
        case .getAccessToken( let client_id,let client_secret, let grant_type , let redirect_uri,let code):
            parmeters["client_id"] = client_id
            parmeters["client_secret"] = client_secret
            parmeters["grant_type"] = grant_type
            parmeters["code"] = code
            parmeters["redirect_uri"] = redirect_uri
            return .requestCompositeParameters(bodyParameters: ["":""], bodyEncoding: JSONEncoding.default, urlParameters: parmeters)
        case .getUserInfo(let access_token,let uid):
            parmeters["access_token"] = access_token
            parmeters["uid"] = uid
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        case .getHomePageData(let access_token,let since_id,let max_id):
            parmeters["access_token"] = access_token
            parmeters["since_id"] = since_id
            parmeters["max_id"] = max_id
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
       
    }
    //如果请求头不一致还需要单独设置请求头，🐶🐶🐶🐶
    var headers: [String : String]? {
        switch self {
        case .getAccessToken(_, _, _, _, _),.getHomePageData(_,_,_):
            return ["Content-type": "application/json"]
        case .getUserInfo(_, _):
            return ["Content-type": "text/plain"]
        default:
            return ["Content-type": "application/json,text/json,text/javascript,text/html,text/plain,application/x-www-form-urlencodem"]
        }
       
    }
    
    
}
