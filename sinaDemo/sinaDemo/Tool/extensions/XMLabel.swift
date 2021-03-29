//
//  XMLabel.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/25.
//

import UIKit
enum TapHandleType {
    case nonHandle
    case userHandle
    case topicHandle
    case linkHandle
    case allTextHandle
}
//行间距
private let linespace: CGFloat = 6

class XMLabel: UILabel {
    
    public var attributeHeight:CGFloat = 0
    
    override var text: String?{
        didSet{
            prepareText()
        }
    }
    override var attributedText: NSAttributedString?{
        didSet{
            prepareText()
        }
    }
    override var font: UIFont!{
        didSet{
            prepareText()
        }
    }
    override var textColor: UIColor!{
        didSet{
            prepareText()
        }
    }
    public var matchLinkTextColor:UIColor = UIColor(red: 29 / 255.0, green: 131 / 255.0, blue: 179 / 255.0, alpha: 1.0) {
        didSet {
            prepareText()
        }
    }
    public var matchUserTextColor:UIColor = UIColor(red: 29 / 255.0, green: 131 / 255.0, blue: 179 / 255.0, alpha: 1.0) {
        didSet {
            prepareText()
        }
    }
    public var matchTopicTextColor:UIColor = UIColor(red: 29 / 255.0, green: 131 / 255.0, blue: 179 / 255.0, alpha: 1.0) {
        didSet {
            prepareText()
        }
    }
    /**
     按照个人理解：
     
     NSTextStorage保存并管理UITextView要展示的文字内容，该类是NSMutableAttributedString的子类，由于可以灵活地往文字添加或修改属性，所以非常适用于保存并修改文字属性。
     
     NSLayoutManager用于管理NSTextStorage其中的文字内容的排版布局。
     
     NSTextContainer则定义了一个矩形区域用于存放已经进行了排版并设置好属性的文字。
     
     以上三者是相互包含相互作用的层次关系。
     */
    //懒加载属性
    //textStorage装载内容的容器,继承自NSMutableAttributedString,其里面保存的东西决定了textview的富文本显示方式
    // [**.textStorage appendAttributedString:attributedStr];
    private lazy var textStorage = NSTextStorage()// NSMutableAttributeString的子类
    private lazy var layoutManager = NSLayoutManager()// 布局管理者
    private lazy var textContainer = NSTextContainer() // 容器,需要设置容器的大小
    
    // 用于记录下标值
    private lazy var linkRanges : [NSRange] = [NSRange]()
    private lazy var userRanges : [NSRange] = [NSRange]()
    private lazy var topicRanges : [NSRange] = [NSRange]()
    private lazy var allTextRanges : [NSRange] = [NSRange]()
    // 用于记录用户选中的range
    private var selectedRange : NSRange?
    
    // 用户记录点击还是松开
    private var isSelected : Bool = false
    
    // 闭包属性,用于回调
    private var tapHandlerType : TapHandleType = TapHandleType.nonHandle
    
    public typealias XMTapHandler = (XMLabel, String, NSRange) -> Void
    public var linkTapHandler : XMTapHandler?
    public var topicTapHandler : XMTapHandler?
    public var userTapHandler : XMTapHandler?
    public var allTextTapHandler : XMTapHandler?

    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    
    // MARK:- 布局子控件
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置容器的大小为Label的尺寸
        textContainer.size = frame.size
    }
    
    // MARK:- 重写drawTextInRect方法
    override public func drawText(in rect: CGRect) {
        // 1.绘制背景
        if selectedRange != nil {
            // 2.0.确定颜色
            let selectedColor = isSelected ? UIColor(white: 0.8, alpha: 0.2) : UIColor.clear
            
            // 2.1.设置颜色
            textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: selectedColor, range: selectedRange!)
            
            // 2.2.绘制背景
            layoutManager.drawBackground(forGlyphRange: selectedRange!, at: CGPoint(x: 0, y: 0))
        }
        
        // 2.绘制字形
        // 需要绘制的范围
        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
}
extension XMLabel{
    /// 准备文本系统
    private func prepareTextSystem() {
        // 0.准备文本
        prepareText()
        
        // 1.将布局添加到storeage中
        textStorage.addLayoutManager(layoutManager)
        
        // 2.将容器添加到布局中
        layoutManager.addTextContainer(textContainer)
        
        // 3.让label可以和用户交互
        isUserInteractionEnabled = true
        
        // 4.设置间距为0
        textContainer.lineFragmentPadding = 0
    }
    /// 准备文本
    private func prepareText() {
        // 1.准备字符串
        var attrString : NSMutableAttributedString = NSMutableAttributedString.init(string: "")
        if attributedText != nil {
            attrString = NSMutableAttributedString.init(attributedString: attributedText!)
        } else if text != nil {
            attrString = NSMutableAttributedString.init(string: text!)
        } else {
            attrString = NSMutableAttributedString.init(string: "")
        }
        
        selectedRange = nil
       
        // 2.设置换行模型
        attrString = addLineBreak(attrString: attrString)
        
        attrString.addAttribute(NSAttributedString.Key.font, value: font ?? 12, range: NSRange(location: 0, length: attrString.length))

        // 3.设置textStorage的内容
        textStorage.setAttributedString(attrString)
        
        // 4.匹配URL
        if let linkRanges = getLinkRanges() {
            self.linkRanges = linkRanges
            for range in linkRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchLinkTextColor, range: range)
            }
        }
        
        // 5.匹配@用户
        if let userRanges = getRanges(pattern: "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*") {
            self.userRanges = userRanges
            for range in userRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchUserTextColor, range: range)
            }
        }
        
        
        // 6.匹配话题##
        if let topicRanges = getRanges(pattern: "#.*?#") {
            self.topicRanges = topicRanges
            for range in topicRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTopicTextColor, range: range)
            }
        }
        // 7.匹配全文
        if let allTextRanges = getRanges(pattern: "全文") {
            self.allTextRanges = allTextRanges
            for range in allTextRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTopicTextColor, range: range)
                textStorage.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range:range)
            }
        }
       
        //8.匹配emoji表情
        if let allEmojiRanges = getRanges(pattern: "\\[.*?\\]") {
            if allEmojiRanges.count > 0 {
                for index in (0...allEmojiRanges.count-1).reversed() {
                    let emojiRang:NSRange = allEmojiRanges[index]
                    let chs = attrString.attributedSubstring(from: emojiRang).string
                    let path = self.findPngPath(chs: chs)
                    if path != nil {
//                        print(path!)
//                        print(emojiRang)
//                        print(allEmojiRanges.count-1)
                        //插入普通表情
                        let attachMent = XMAttachment()
                        attachMent.chs = chs
                        attachMent.image = UIImage(contentsOfFile: path!)
                        let font = self.font!
                        attachMent.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                        let attrImageStr = NSAttributedString(attachment: attachMent)
                        textStorage.replaceCharacters(in: emojiRang, with: attrImageStr)
                    }
                }
            }
            
        }
        //9.设置高度
        if attrString.length > 0 {
            self.attributeHeight = self.autoLabelHeight(with: attrString, labelWidth: self.bounds.width)
        }else {
            self.attributeHeight = 0
        }
        setNeedsDisplay()
    }
    
    /// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置
    private func addLineBreak(attrString: NSMutableAttributedString) -> NSMutableAttributedString {
        let attrStringM = attrString
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        paragraphStyle?.lineSpacing = linespace
        return attrStringM
    }
}
// MARK:- 字符串匹配封装
extension XMLabel {
    private func getRanges(pattern : String) -> [NSRange]? {
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        return getRangesFromResult(regex: regex)
    }
    
    private func getLinkRanges() -> [NSRange]? {
        // 创建正则表达式
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        return getRangesFromResult(regex: detector)
    }
    
    private func getRangesFromResult(regex : NSRegularExpression) -> [NSRange] {
        // 1.匹配结果
        let results = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        // 2.遍历结果
        var ranges = [NSRange]()
        for res in results {
            ranges.append(res.range)
        }
        
        return ranges
    }
    private func findPngPath(chs:String)->String?{
        let path = EmotionPakageManager.shareManager.PackageMap[chs]
        return path
    }
}

// MARK:- 点击交互的封装
extension XMLabel {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 0.记录点击
        isSelected = true
        
        // 1.获取用户点击的点
        let selectedPoint = touches.first!.location(in: self)
        
        // 2.获取该点所在的字符串的range
        selectedRange = getSelectRange(selectedPoint: selectedPoint)
        
        // 3.是否处理了事件
        if selectedRange == nil {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if selectedRange == nil {
            super.touchesEnded(touches, with: event)
            return
        }
        // 0.记录松开
        isSelected = false
        // 2.重新绘制(点击背景)
        setNeedsDisplay()
        // 3.取出内容
        let contentText = (textStorage.string as NSString).substring(with: selectedRange!)
        
        // 3.回调
        switch tapHandlerType {
        case .linkHandle:
            linkTapHandler?(self, contentText, selectedRange!)
            
        case .topicHandle:
            topicTapHandler?(self, contentText, selectedRange!)
            
        case .userHandle:
            userTapHandler?(self, contentText, selectedRange!)
            
        case .allTextHandle:
            allTextTapHandler?(self, contentText, selectedRange!)
            
        default:
            break
        }
    }
    
    private func getSelectRange(selectedPoint : CGPoint) -> NSRange? {
        // 0.如果属性字符串为nil,则不需要判断
        if textStorage.length == 0 {
            return nil
        }
        
        // 1.获取选中点所在的下标值(index)
        let index = layoutManager.glyphIndex(for: selectedPoint, in: textContainer)
        
        // 2.判断下标在什么内
        // 2.1.判断是否是一个链接
        for linkRange in linkRanges {
            if index > linkRange.location && index < linkRange.location + linkRange.length {
                setNeedsDisplay()
                tapHandlerType = .linkHandle
                return linkRange
            }
        }
        
        // 2.2.判断是否是一个@用户
        for userRange in userRanges {
            if index > userRange.location && index < userRange.location + userRange.length {
                setNeedsDisplay()
                tapHandlerType = .userHandle
                return userRange
            }
        }
        
        // 2.3.判断是否是一个#话题#
        for topicRange in topicRanges {
            if index > topicRange.location && index < topicRange.location + topicRange.length {
                setNeedsDisplay()
                tapHandlerType = .topicHandle
                return topicRange
            }
        }
        // 2.4.判断是否全文
        for allTextRange in allTextRanges {
            if index > allTextRange.location && index < allTextRange.location + allTextRange.length {
                setNeedsDisplay()
                tapHandlerType = .allTextHandle
                return allTextRange
            }
        }
        return nil
    }
}
extension XMLabel {
    
    /// label高度自适应
    /// - Parameters:
    ///   - text: 必须是NSMutableAttributedString
    ///   - labelWidth: 宽度
    /// - Returns: 高度
    func autoLabelHeight(with text:NSMutableAttributedString , labelWidth: CGFloat) -> CGFloat{

        let height = text.boundingRect(with: CGSize(width: labelWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).size.height
        return height
    }
    
}
