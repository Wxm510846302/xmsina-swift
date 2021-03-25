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
        var attrString : NSAttributedString?
        if attributedText != nil {
            attrString = attributedText
        } else if text != nil {
            attrString = NSAttributedString(string: text!)
        } else {
            attrString = NSAttributedString(string: "")
        }
        
        selectedRange = nil
        
        // 2.设置换行模型
        let attrStringM = addLineBreak(attrString: attrString!)
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置
        paraph.lineSpacing = 5
        
        attrStringM.addAttribute(NSAttributedString.Key.font, value: font ?? 0, range: NSRange(location: 0, length: attrStringM.length))
        
        attrStringM.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraph, range: NSRange(location: 0, length: attrStringM.length))
        
        // 3.设置textStorage的内容
        textStorage.setAttributedString(attrStringM)
        
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
     
//        self.attributeHeight = self.autoLabelHeight(with: self.attributedText!, labelWidth: self.bounds.size.width, attributes: [NSAttributedString.Key.paragraphStyle:paraph,NSAttributedString.Key.foregroundColor:matchTopicTextColor,NSAttributedString.Key.font:self.font!])
        self.attributeHeight = self.calcTextSize(fitsSize: CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT)), text: self.attributedText!, numberOfLines: 0, font: self.font!, textAlignment: .left, lineBreakMode: .byTruncatingTail, minimumScaleFactor: 0, shadowOffset: CGSize.zero).height
        setNeedsDisplay()
    }
    
    /// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置
    private func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
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
    ///label高度自适应
    /// - Parameters:
    ///   - text: 文字
    ///   - labelWidth: 最大宽度
    ///   - attributes: 字体，行距等
    /// - Returns: 高度
    func autoLabelHeight(with text:NSAttributedString , labelWidth: CGFloat ,attributes : [NSAttributedString.Key : Any]) -> CGFloat{
        var size = CGRect()
        let size2 = CGSize(width: labelWidth, height: CGFloat(MAXFLOAT))//设置label的最大宽度
        size = text.boundingRect(with: size2, options: .usesLineFragmentOrigin, context: nil)
        return size.size.height
    }
    /// 使用此方法时请标明源作者：欧阳大哥2013。本方法符合MIT协议规范。
    /// github地址：https://github.com/youngsoft
    /// 计算简单文本或者属性字符串的自适应尺寸
    /// @param fitsSize 指定限制的尺寸，参考UILabel中的sizeThatFits中的参数的意义。
    /// @param text 要计算的简单文本NSString或者属性字符串NSAttributedString对象
    /// @param numberOfLines 指定最大显示的行数，如果为0则表示不限制最大行数
    /// @param font 指定计算时文本的字体，可以为nil表示使用UILabel控件的默认17号字体
    /// @param textAlignment 指定文本对齐方式默认是NSTextAlignmentNatural
    /// @param lineBreakMode 指定多行时断字模式，默认可以用UILabel的默认断字模式NSLineBreakByTruncatingTail
    /// @param minimumScaleFactor 指定文本的最小缩放因子，默认填写0。这个参数用于那些定宽时可以自动缩小文字字体来自适应显示的场景。
    /// @param shadowOffset 指定阴影的偏移位置，需要注意的是这个偏移位置是同时指定了阴影颜色和偏移位置才有效。如果不考虑阴影则请传递CGSizeZero，否则阴影会参与尺寸计算。
    /// @return 返回自适应的最合适尺寸
    func calcTextSize(fitsSize:CGSize,
                      text:NSAttributedString,
                      numberOfLines:Int,
                      font:UIFont = UIFont.systemFont(ofSize: 17),
                      textAlignment:NSTextAlignment,
                      lineBreakMode:NSLineBreakMode,
                      minimumScaleFactor:CGFloat,
                      shadowOffset:CGSize) -> CGSize{
        
        if (text.string.count <= 0) {
            return CGSize.zero;
        }
        var calcAttributedString:NSAttributedString? = nil
        let systemVersion = UIDevice.current.systemVersion.floatValue
        var paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment;
        paragraphStyle.lineBreakMode = lineBreakMode;
        //系统大于等于11才设置行断字策略。
        if (systemVersion >= 11.0) {
            paragraphStyle.setValue(1, forKey: "lineBreakStrategy")
        }
        let originAttributedString = text
        //对于属性字符串总是加上默认的字体和段落信息。
        let mutableCalcAttributedString = NSMutableAttributedString.init(string: originAttributedString.string, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle : paragraphStyle])
        //再附加上原来的属性。
        originAttributedString.enumerateAttributes(in: NSRange(location: 0, length: originAttributedString.length), options: [.longestEffectiveRangeNotRequired]) { (attributes:[NSAttributedString.Key : Any], range:NSRange, pointer:UnsafeMutablePointer<ObjCBool>) in
            mutableCalcAttributedString.addAttributes(attributes, range: range)
        }

            //这里再次取段落信息，因为有可能属性字符串中就已经包含了段落信息。
            if (systemVersion >= 11.0) {
              
                
                
                if let alternativeParagraphStyle:NSMutableParagraphStyle = mutableCalcAttributedString.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle {
                    
                    paragraphStyle = alternativeParagraphStyle
                }
            }
            
            calcAttributedString = mutableCalcAttributedString;
        
        var fitsSize = fitsSize
        //调整fitsSize的值, 这里的宽度调整为只要宽度小于等于0或者显示一行都不限制宽度，而高度则总是改为不限制高度。
        fitsSize.height = CGFloat(MAXFLOAT);
        if (fitsSize.width <= 0 || numberOfLines == 1) {
            fitsSize.width = CGFloat(MAXFLOAT);
        }
            
        //构造出一个NSStringDrawContext
        let context:NSStringDrawingContext = NSStringDrawingContext.init()
        context.minimumScaleFactor = minimumScaleFactor;
        context.setValue(numberOfLines, forKey: "maximumNumberOfLines")
        if (numberOfLines != 1) {
            context.setValue(true, forKey: "wrapsForTruncationMode")
        }
        context.setValue(true, forKey: "wantsNumberOfLineFragments")
       

        //计算属性字符串的bounds值。
        var rect:CGRect = calcAttributedString!.boundingRect(with: fitsSize, options: .usesLineFragmentOrigin, context: context)
        
        //需要对段落的首行缩进进行特殊处理！
        //如果只有一行则直接添加首行缩进的值，否则进行特殊处理。。
        let firstLineHeadIndent:CGFloat = paragraphStyle.firstLineHeadIndent
        
        if (firstLineHeadIndent != 0.0 && systemVersion >= 11.0) {
            //得到绘制出来的行数
            let numberOfDrawingLines:Int = context.value(forKey: "numberOfLineFragments") as! Int
    
            if (numberOfDrawingLines == 1) {
                rect.size.width += firstLineHeadIndent;
            } else {
                //取内容的行数。
                let string = calcAttributedString?.string
                let charset:CharacterSet = NSCharacterSet.newlines
                let lines = string!.components(separatedBy: charset) //得到文本内容的行数
                let lastLine = lines.last
                let numberOfContentLines = lines.count - (lastLine?.count == 0 ? 1: 0)//有效的内容行数要减去最后一行为空行的情况。
                var numberOfLines = numberOfLines
                if (numberOfLines == 0) {
                    numberOfLines = NSIntegerMax;
                }
                if (numberOfLines > numberOfContentLines){
                    numberOfLines = numberOfContentLines;
                }
                //只有绘制的行数和指定的行数相等时才添加上首行缩进！这段代码根据反汇编来实现，但是不理解为什么相等才设置？
                if (numberOfDrawingLines == numberOfLines) {
                    rect.size.width += firstLineHeadIndent;
                }
            }
        }
        
        //取fitsSize和rect中的最小宽度值。
        if (rect.size.width > fitsSize.width) {
            rect.size.width = fitsSize.width;
        }
        
        //加上阴影的偏移
        rect.size.width += abs(shadowOffset.width);
        rect.size.height += abs(shadowOffset.height);
           
        //转化为可以有效显示的逻辑点, 这里将原始逻辑点乘以缩放比例得到物理像素点，然后再取整，然后再除以缩放比例得到可以有效显示的逻辑点。
        let scale = UIScreen.main.scale
        rect.size.width = ceil(rect.size.width * scale) / scale;
        rect.size.height = ceil(rect.size.height * scale) / scale;
        return rect.size;
    }

    //上述方法的精简版本
    func calcTextSizeV2(fitsSize:CGSize,text:NSAttributedString,numberOfLines:Int,font:UIFont) -> CGSize {
        return calcTextSize(fitsSize: fitsSize, text: text, numberOfLines: numberOfLines, font: font, textAlignment: NSTextAlignment.natural, lineBreakMode: NSLineBreakMode.byTruncatingTail,minimumScaleFactor: 0.0, shadowOffset: CGSize.zero);
    }

}
