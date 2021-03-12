//
//  HomeCell.swift
//  sinaDemo
//
//  Created by admin on 2021/3/7.
//

import UIKit
import SDWebImage
let itemMargin = CGFloat(12).auto()
let edgeMargin = CGFloat(10).auto()

class HomeCell: UITableViewCell {

    @IBOutlet weak var zhuanfaBackImg: UIImageView!
    @IBOutlet weak var dianzan: UIButton!
    @IBOutlet weak var pinglun: UIButton!
    @IBOutlet weak var zhuanfa: UIButton!
    @IBOutlet weak var picConstraintH: NSLayoutConstraint!
    @IBOutlet weak var picConstraintW: NSLayoutConstraint!
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var zhuanfaTop: NSLayoutConstraint!
    @IBOutlet weak var picBottom: NSLayoutConstraint!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var crateAt: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var myText: UILabel!
    @IBOutlet weak var reteewText: UILabel!
    var HomeViewModel:HomeModelTool?{
        didSet {
            guard let viewModel = HomeViewModel else {
                return
            }
            //设置头像
            self.iconImg.sd_setImage(with: URL.init(string: viewModel.homeModel?.user?.avatar_large ?? ""), completed: nil)
            //设置认证
            
            //设置昵称
            self.screenName.text =  viewModel.homeModel?.user?.screen_name ?? ""
            //设置时间
            self.crateAt.text = viewModel.creatAtText ?? ""
            //设置来源
            self.source.text = viewModel.courceText ?? ""
            //设置文字
            self.myText.text = viewModel.homeModel?.text ?? ""
            //设置昵称文字颜色
            
            if viewModel.homeModel?.retweeted_status != nil {
                //有转发
                self.zhuanfaBackImg.isHidden = false

            }else{
                //没有转发内容
                self.zhuanfaBackImg.isHidden = true

            }
            //设置转发内容
            if let retext = viewModel.homeModel?.retweeted_status?.text {
                let retweeName = viewModel.homeModel?.retweeted_status?.user?.screen_name ?? ""
                if retweeName.count > 0 {
                    self.reteewText.text = "@\(retweeName): " +  retext
                }
                zhuanfaTop.constant = 10
                
            }else{
                zhuanfaTop.constant = 0
                self.reteewText.text = ""
            }
            let picCount =  viewModel.picUrls.count
            //计算pic的宽度和高度约束
            let PicViewSize = calculatePicViewSize(count:picCount)
            picConstraintH.constant =  PicViewSize.height
            picConstraintW.constant =  PicViewSize.width
            
            picCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImg.layer.masksToBounds = true
        self.iconImg.layer.cornerRadius = self.iconImg.frame.width/2
        
//        constraintW.constant = kScreenWidth - CGFloat( edgeMargin * 2)
        picCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCellId")
        picCollectionView.dataSource = self
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HomeCell{
    private func calculatePicViewSize(count:Int)->CGSize{
        
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //没有配图
        if count == 0 {

            picBottom.constant = 0
            return CGSize.zero
        }

        picBottom.constant = 10
        if count == 1 {
            let str = self.HomeViewModel!.picUrls.last!
            let image = SDImageCache.shared.imageFromDiskCache(forKey: str)
            let size =  CGSize.init(width: (image!.size.width) * 2, height: (image!.size.height) * 2)
            //布局picview
            layout.itemSize = size
//            layout.minimumLineSpacing = itemMargin.floatValue
            return size
        }
        
        //布局picview
        let imageWH = (kScreenWidth - edgeMargin.floatValue * 2 -  itemMargin.floatValue * 2) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
//        layout.minimumLineSpacing = itemMargin.floatValue
        
        //4个配图
        if count == 4{
            let picViewWH = imageWH * 2 + itemMargin.floatValue
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        let numberLine = ((count - 1)/3 + 1).floatValue
        let picViewH = imageWH * numberLine + itemMargin.floatValue * (numberLine - 1)
        let picViewW = kScreenWidth - 2 * edgeMargin.floatValue
    
        return CGSize(width: picViewW, height: picViewH)
    }
}
extension HomeCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.HomeViewModel?.picUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCellId", for: indexPath) as! ItemCell
//        cell.backgroundColor = .red
        
        guard let ImageUrl = self.HomeViewModel?.picUrls[indexPath.row] else {
            return cell
        }
        cell.backImg.sd_setImage(with: URL.init(string: ImageUrl), completed: nil)
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
