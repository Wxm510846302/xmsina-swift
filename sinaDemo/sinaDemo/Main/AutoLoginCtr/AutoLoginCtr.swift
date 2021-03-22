//
//  AutoLoginCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
import WebKit
import Moya
class AutoLoginCtr: UIViewController {
    var userModel:UserCount?
    var getedToken:Bool = false
    lazy var dispatchGroup = DispatchGroup.init()
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavUI()
        requestUrl()
    }
    deinit {
        print("AutoLoginCtr deinit")
    }
}

// MARK: - 设置ui界面

extension AutoLoginCtr{
    func setNavUI()  {
        title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:  "关闭", style: .plain, target: self, action: #selector(self.closeClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(self.loginCountClick))
    }
}
// MARK: - 点击事件

extension AutoLoginCtr{
    @objc private func closeClick() {
      
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc private func loginCountClick(){
    
        let jscode = "document.getElementById（'userId'）.value = '17801311135'; document.getElementById（'passwd'）.value = 'wxm18231178020'"
        webView.evaluateJavaScript(jscode, completionHandler: nil)
    }
    
    private func requestUrl(){
        
        guard let url:URL = URL.init(string: "https://api.weibo.com/oauth2/authorize?client_id=\(sinaAppKey)&redirect_uri=\(sinaRedirectUrl)") else {
            
            return
        }
        let request = URLRequest.init(url: url)
        webView.navigationDelegate = self
        webView.load(request)
        
        
    }
}
// MARK: - 其他网络请求

extension AutoLoginCtr{
    
    // MARK: - 利用GCD来配合网络请求
    private func useGCDtoGetTokenAndUserInfo(userCode:String){
        //创建自定义异步队列，不用全局队列，防止对全局队列有什么不好的影响
        let queue = DispatchQueue.init(label: "loginQueue",attributes: .concurrent)
        self.dispatchGroup.enter()//必须在这里加入group，不能再queue.async里，否则notify操作先执行
        self.dispatchGroup.enter()
        queue.async {
            //在异步队列里执行异步线程。防止由于getAccessToken接口有问题，从而阻塞主线程
//在getAccessToken 里用信号量控制一下，先让getAccessToken执行完毕后再进行getUserMsg
            self.getAccessToken(code: userCode)
            self.getUserMsg()
        }
        
        self.dispatchGroup.notify(queue: queue) {
            print("notify-已经获得结果-必须在主线程操作UI")
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: false, completion: {
                    //切换跟控制器
                    UIApplication.shared.keyWindow?.rootViewController = WelcomeCtr.init()

                })
            }
        }
        print("此时处于主线程-不会阻塞-执行了获取token操作-结果待定")
    }
    
    private func getAccessToken(code:String)  {
        self.getedToken = true
        //当前队列是是loginQueue，DispatchSemaphore信号量来保证先执行获取token的方法 sema.wait()阻塞当前线程
        print("此时处于loginQueue队列的线程 getAccessToken")
        let sema = DispatchSemaphore(value: 0)
        xmProvider.request(.getAccessToken(client_id: sinaAppKey, client_secret: sinaAppSecret, grant_type:"authorization_code", redirect_uri: sinaRedirectUrl, code: code)) { (result:Result<Response, MoyaError>) in
            if case .success(let response) = result {
                // 解析数据
                let jsonDic = try! response.mapJSON() as! NSDictionary
                self.userModel = UserCount.deserialize(from: jsonDic)
                sema.signal()
                self.dispatchGroup.leave()
                print("getAccessTokened")
            }
        
        }
        sema.wait()
        
    }
    private func getUserMsg() {
        print("getUserMsg")
        let token:String = self.userModel!.access_token ?? ""
        xmProvider.request(.getUserInfo(access_token: token, uid: self.userModel!.uid!)) { (result:Result<Response, MoyaError>) in
//            print(result)
            if case .success(let response) = result{
                if try! result.get().statusCode == 200 {
                    let jsonDic = try! response.mapJSON() as! [String:Any]
                    if let oldDic = self.userModel?.toJSON() {
                        let newDic = jsonDic.merging(oldDic) { (shopParamaKeyValue, oldDic) -> Any in
                            return shopParamaKeyValue
                        }
                        print("getUserMsged")
                        self.userModel = UserCount.deserialize(from: newDic)
                        UserCountManager.saveUserCount(user: self.userModel!)
                        self.dispatchGroup.leave()
                        
                    }
                }
                
            }
        }
        
    }
}
// MARK: - webview代理方法

extension AutoLoginCtr:WKNavigationDelegate{
    //链接开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    //加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    //加载错误时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    //    @available(iOS 13.0, *)//拿到响应后决定是否允许跳转
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
    //        print("decidePolicyFor navigationAction preferences")
    //    }
    
    //判断链接是否允许跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //        print("decidePolicyFor navigationAction")
        guard let urlstring = navigationAction.request.url?.absoluteString else {
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        
        if urlstring.components(separatedBy: "code=").count == 2  &&  urlstring.components(separatedBy: sinaRedirectUrl).count == 2{
            if !self.getedToken {
                //请求token和个人信息
                self.useGCDtoGetTokenAndUserInfo(userCode: urlstring.components(separatedBy: "code=").last!)
            }
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            //            webView.load(URLRequest.init(url: URL.init(string: "")!))
            return
            
        }else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
    }
    
    //拿到响应后决定是否允许跳转
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //        print("decidePolicyFor navigationResponse")
    //        decisionHandler(WKNavigationResponsePolicy.allow)
    //    }
    
    //收到服务器重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    //当内容开始到达主帧时被调用（即将完成）
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    //在提交的主帧中发生错误时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //当webView的web内容进程被终止时调用。(iOS 9.0之后)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    //当webView需要响应身份验证时调用(如需验证服务器证书)
    //    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    //
    //    }
    //    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
    //
    //    }
}
