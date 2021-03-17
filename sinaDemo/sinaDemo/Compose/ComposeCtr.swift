//
//  ComposeCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/17.
//

import UIKit

class ComposeCtr: UIViewController{
    
    @IBOutlet weak var toolBottom: NSLayoutConstraint!
    @IBOutlet weak var myToolBar: UIToolbar!
    @IBOutlet weak var myTextView: XMTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        addObeservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myTextView.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func setUpNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(self.backClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(self.backClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "发布"
        //       navigationItem.prompt = "说点什么"
    }
    private func addObeservers(){
        //键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBordNotification(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
extension ComposeCtr{
    @objc private func backClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func keyBordNotification(noti:Notification){
        let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endframe = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let margin = kScreenHeight - endframe.cgRectValue.origin.y
        UIView.animate(withDuration: duration) {
            self.toolBottom.constant = margin
        }
    }
}
// MARK: - 代理

extension ComposeCtr:UITextViewDelegate,UIScrollViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            (textView as! XMTextView).placeHoldLb.text = ""
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            (textView as! XMTextView).placeHoldLb.text = (textView as! XMTextView).placeHoldText
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.myTextView.resignFirstResponder()
    }
}
