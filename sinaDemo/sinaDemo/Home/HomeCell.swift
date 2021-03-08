//
//  HomeCell.swift
//  sinaDemo
//
//  Created by admin on 2021/3/7.
//

import UIKit
let itemMargin = CGFloat(12).auto()
let edgeMargin = CGFloat(10).auto()

class HomeCell: UITableViewCell {

    @IBOutlet weak var zhuanfaBackImg: UIImageView!
    @IBOutlet weak var dianzan: UIButton!
    @IBOutlet weak var pinglun: UIButton!
    @IBOutlet weak var zhuanfa: UIButton!
    @IBOutlet weak var constraintW: NSLayoutConstraint!
    @IBOutlet weak var picConstraintH: NSLayoutConstraint!
    @IBOutlet weak var picConstraintW: NSLayoutConstraint!
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    @IBOutlet weak var zhuanfaTop: NSLayoutConstraint!
    @IBOutlet weak var zhuanfaBottom: NSLayoutConstraint!
    @IBOutlet weak var picBottom: NSLayoutConstraint!
    var HomeViewModel:HomeModelTool?{
        didSet {
            guard let viewModel = HomeViewModel else {
                return
            }
            //设置头像
            //设置认证
            //设置昵称
            //设置时间
            //设置来源
            //设置昵称文字颜色
            //计算pic的宽度和高度约束
            picCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintW.constant = kScreenWidth - CGFloat( edgeMargin * 2)
        picCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCellId")
        picCollectionView.dataSource = self
        //布局picview
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let imageViewWH = (kScreenWidth - edgeMargin.floatValue * 2 -  itemMargin.floatValue * 2) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        layout.minimumLineSpacing = itemMargin.floatValue
        let PicViewSize = calculatePicViewSize(count: 5)
        
//        zhuanfaBottom.constant = 0
//        zhuanfaTop.constant = 0

        picConstraintH.constant =  PicViewSize.height
        picConstraintW.constant =  PicViewSize.width

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeCell{
    private func calculatePicViewSize(count:Int)->CGSize{
        //没有配图
        if count == 0 {
            picBottom.constant = 0
            return CGSize.zero
        }
       //计算出imageViewWH
        let imageViewWH = (kScreenWidth - edgeMargin.floatValue * 2 -  itemMargin.floatValue * 2) / 3
        //4个配图
        if count == 4{
            let picViewWH = imageViewWH * 2 + itemMargin.floatValue
            
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        let numberLine = ((count - 1)/3 + 1).floatValue
        let picViewH = imageViewWH * numberLine + itemMargin.floatValue * (numberLine - 1)
        let picViewW = kScreenWidth - 2 * edgeMargin.floatValue
    
        return CGSize(width: picViewW, height: picViewH)
    }
}
extension HomeCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.HomeViewModel?.picUrls?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCellId", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}
class ItemCell: UICollectionViewCell {
    
    var backImg:UIImageView = UIImageView.init()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backImg.frame = self.contentView.bounds
        self.contentView.addSubview(self.backImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
