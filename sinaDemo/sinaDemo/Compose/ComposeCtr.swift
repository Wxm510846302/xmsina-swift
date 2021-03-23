//
//  ComposeCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/17.
//

import UIKit
import ZLPhotoBrowser
import RxSwift
class ComposeCtr: UIViewController{
    var choosedImages:[UIImage] = [UIImage]() {
        didSet{
            self.picPickerView.picImages = choosedImages
            if choosedImages.count > 0 && self.myTextView.text.count == 0 {
                self.myTextView.text = "分享图片"
                navigationItem.rightBarButtonItem?.isEnabled = true
            }else {
                
            }
        }
    }
    //进入选择图片控制器
    var presentedPicPicker:Bool = false
    @IBOutlet weak var picPickerH: NSLayoutConstraint!
    @IBOutlet weak var picPickerView: ComposePicCollotionView!
    @IBOutlet weak var toolBottom: NSLayoutConstraint!
    @IBOutlet weak var myToolBar: UIToolbar!
    @IBOutlet weak var myTextView: XMTextView!
    @IBAction func textClick() {
        
        UIView.animate(withDuration: 0.3) {
            self.myTextView.resignFirstResponder()
            self.myTextView.inputView = nil
            self.myTextView.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func choosePicClick() {
        self.myTextView.resignFirstResponder()
        //弹出照片展示页面
        self.picPickerH.constant = kScreenHeight * 0.65
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func showEmotionClick(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) {
            self.myTextView.resignFirstResponder()
            self.myTextView.inputView = EmotionIconCtr.init(textView: self.myTextView).view
            self.myTextView.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        addObeservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presentedPicPicker == false {
            myTextView.becomeFirstResponder()
        }
    }
    deinit {
        print("ComposeCtr deinit")
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 弹出第三方选择图片view

extension ComposeCtr {
    
    private func browser(images:[UIImage],currentIndex:Int)  {
        
       let picbrwoser =  ZLImagePreviewController.init(datas: images, index: currentIndex, showSelectBtn: true, showBottomView: true, urlType: nil, urlImageLoader: nil)
        picbrwoser.modalPresentationStyle = .fullScreen
        picbrwoser.doneBlock = { [weak self]( objc:Any) in
            self?.choosedImages = objc as! [UIImage]
        };

        self.present(picbrwoser, animated: true, completion: nil)
    }

    private func showImagePicker(_ preview: Bool) {
        
        let config = ZLPhotoConfiguration.default()
        config.languageType = .chineseSimplified
        config.maxSelectCount =  9 - self.choosedImages.count
//        config.style = .externalAlbumList
//        config.editImageClipRatios = [.custom, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)]
//        config.filters = [.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)]
//        config.imageStickerContainerView = ImageStickerContainerView()
        config.canSelectAsset = { (asset) -> Bool in
            return true
        }
        config.allowSelectVideo = false
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                debugPrint("No library authority")
            case .camera:
                debugPrint("No camera authority")
            case .microphone:
                debugPrint("No microphone authority")
            }
        }
        
        let ac = ZLPhotoPreviewSheet(selectedAssets: [])
        ac.selectImageBlock = { [weak self] (images, assets, isOriginal) in
//            self?.presentedPicPicker = false
            debugPrint("\(images)   \(assets)   \(isOriginal)")
            for image in images {
                self?.choosedImages.append(image)
            }
//            self?.picPickerView.picImages = self?.choosedImages ?? []
        }
        ac.cancelBlock = {[weak self] in
            self?.presentedPicPicker = false
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = {[weak self] (errorAssets, errorIndexs) in
            self?.presentedPicPicker = false
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        
        if preview {
            ac.showPreview(animate: true, sender: self)
        } else {
            ac.showPhotoLibrary(sender: self)
        }
        self.presentedPicPicker = true
    }
}
// MARK: - 返回和键盘监听回调

extension ComposeCtr{
    @objc private func composeClick(){
        self.myTextView.getAttributeString()
//        dismiss(animated: true, completion: nil)
    }
    @objc private func backClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func keyBordNotification(noti:Notification){
        let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endframe = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let margin = kScreenHeight - endframe.cgRectValue.origin.y
        UIView.animate(withDuration: duration) {
            if margin > 0 {
                self.toolBottom.constant = margin - kBottomSafeHeight
                self.picPickerH.constant = 0
                self.view.layoutIfNeeded()
            }
            else{
                self.toolBottom.constant = 0
            }
        }
    }
    private func setUpNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(self.backClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(self.composeClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.title = "发布"
        //       navigationItem.prompt = "说点什么"
        self.picPickerView.picImages = self.choosedImages
    }
    private func addObeservers(){
        self.picPickerView.delegate = self
        //键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBordNotification(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.deletePic(noti:)), name:  Notification.Name.init(rawValue: "deletePic"), object: nil)
    }
    @objc private func deletePic(noti:Notification){
        if self.choosedImages.contains(noti.object as! UIImage) {
            guard let index = self.choosedImages.firstIndex(of: noti.object as! UIImage) else { return  }
           self.choosedImages.remove(at: index)
        }
    }
}
// MARK: - 代理

extension ComposeCtr:UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate{
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.picPickerView.picImages.count - 1  && self.choosedImages.count < 9{
            //点击的加号
            self.showImagePicker(true)
        }else {
            //查看图片
            self.browser(images: self.choosedImages, currentIndex: indexPath.item)
        }
    }
}
