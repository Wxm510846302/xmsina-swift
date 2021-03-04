//
//  AutoLoginCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/4.
//

import UIKit
import WebKit

class AutoLoginCtr: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavUI()
        requestUrl()
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
        print("closeClick")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc private func loginCountClick(){
        print("loginCountClick")
        let jscode = "document.getElementById（'userId'）.value = '18231178020'; document.getElementById（'passwd'）.value = 'wxm510846302'"
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
    func getAccessToken(code:String)  {
//        params[@"client_id"] = @"1988294129";
//        params[@"client_secret"] = @"263a43f9b7511a222bfbfdfd2bdfdc82";
//        params[@"grant_type"] = @"authorization_code";
//        params[@"redirect_uri"] = @"http://www.baidu.com";
//        params[@"code"] = code;
        let params = ["client_id":sinaAppKey,"client_secret":sinaAppSecret,"grant_type":"authorization_code","redirect_uri":sinaRedirectUrl,"code":code]
        XMNetWorkTool.shareNetworkTool.requestWithNetworkTool(methd: .POST, url: "https://api.weibo.com/oauth2/access_token", params: params, headers: nil) { (error, response) in
            if error == nil{
                print(response ?? "失败")
                guard let dic = response as? [String:Any] else {
                    return
                }
                let user = UserCount.init(dic: dic)
                UserCountManager.saveUserCount(user: user)
            }else{
                print(error!)
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
            getAccessToken(code: urlstring.components(separatedBy: "code=").last!)
            print("接口请求accesstoken")
            decisionHandler(WKNavigationActionPolicy.cancel)
            webView.stopLoading()
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
