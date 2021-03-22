//
//  EmotionIconCtr.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/22.
//

import UIKit
let EmotionCell = "EmotionCellID"
class EmotionIconCtr: UIViewController {
    lazy var Packages:[EmotionPackage] = EmotionPakageManager.init().packages
    lazy var currentPackage = self.Packages.first!
    lazy var deleteBtn = UIButton.init().then {
        $0.addTarget(self, action: #selector(self.deleteClick), for: .touchUpInside)
        $0.frame.size = CGSize(width: kScreenWidth / 8, height: kScreenWidth / 8)
        $0.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
        $0.setImage(UIImage.init(named: "compose_emotion_delete_highlighted"), for: .highlighted)
    }
    lazy var barTool = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)).then {
        $0.backgroundColor = .gray
    }
    lazy var collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: EmotionLayout()).then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpSubViews()
    }
    func SetUpSubViews()  {
//        print(self.view.bounds.height)
        view.addSubview(barTool)
        view.addSubview(collectionView)
        view.addSubview(deleteBtn)
        barTool.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        //VFL
        let views =  ["toolBar":barTool,"collection":collectionView,"btn":deleteBtn]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics:nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[toolBar]-0-[collection]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[btn]-safe-|", options: [.alignAllRight], metrics: ["top": 230,"safe":kBottomSafeHeight], views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[btn]-20-|", options: [], metrics: ["left": (kScreenWidth / 9 * 8 - 20)], views: views)
        view.addConstraints(cons)
        
        prepareForCollectionView()
        prepareForToolBar()
    }
   
    private func prepareForCollectionView(){
        collectionView.register(EmotionItemCell.self, forCellWithReuseIdentifier: EmotionCell)
        collectionView.dataSource = self
    }
    private func prepareForToolBar(){
        let titles = ["最近","默认","emoji","浪花"]
        var index = 0
        var tempArr = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.toolBarClick(item:)))
            item.tag = index
            item.tintColor = .orange
            index += 1
            tempArr.append(item)
            tempArr.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempArr.removeLast()
        barTool.items = tempArr
    }
    @objc private func toolBarClick(item:UIBarButtonItem) {
        self.currentPackage = self.Packages[item.tag]
        self.collectionView.reloadData()
    }
    @objc private func deleteClick(){
        
    }
}
extension EmotionIconCtr : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.currentPackage.emoticons.count + 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell, for: indexPath) as! EmotionItemCell
        if indexPath.item >= self.currentPackage.emoticons.count {
            cell.backImg.setTitle("", for: .normal)
            cell.backImg.setImage(nil, for: .normal)
            return cell
        }
        if self.currentPackage.emoticons[indexPath.item].path.count > 0{
            cell.backImg.setImage(UIImage(contentsOfFile:self.currentPackage.emoticons[indexPath.item].path), for: .normal)
            cell.backImg.setTitle("", for: .normal)
        }else if self.currentPackage.emoticons[indexPath.item].code.count > 0{
            cell.backImg.setTitle(self.currentPackage.emoticons[indexPath.item].code, for: .normal)
            cell.backImg.setImage(nil, for: .normal)
        }else{
            cell.backImg.setTitle("", for: .normal)
            cell.backImg.setImage(nil, for: .normal)
        }
        return cell
    }
    
}
class EmotionItemCell: UICollectionViewCell {
    lazy var backImg:UIButton = UIButton.init().then {
        $0.frame = self.contentView.bounds
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(backImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class EmotionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        itemSize = CGSize(width: kScreenWidth / 9, height: kScreenWidth / 9)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
