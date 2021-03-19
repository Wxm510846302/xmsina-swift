//
//  HomeCell.swift
//  sinaDemo
//
//  Created by admin on 2021/3/7.
//

import UIKit
import SDWebImage
let itemMargin = CGFloat(8).auto()
let edgeMargin = CGFloat(12).auto()

class HomeCell: UITableViewCell {
    var index:IndexPath?
    
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
            //设置底部工具栏的文字
            if viewModel.homeModel!.reposts_count ?? 0 > 0 {
                self.zhuanfa.setTitle("\(viewModel.homeModel!.reposts_count!)", for: .normal)
            }else{
                self.zhuanfa.setTitle("转发", for: .normal)
            }
            if viewModel.homeModel!.comments_count ?? 0 > 0 {
                self.pinglun.setTitle("\(viewModel.homeModel!.comments_count!)", for: .normal)
            }else{
                self.pinglun.setTitle("评论", for: .normal)
            }
            if viewModel.homeModel!.attitudes_count ?? 0 > 0 {
                self.dianzan.setTitle("\(viewModel.homeModel!.attitudes_count!)", for: .normal)
            }else{
                self.dianzan.setTitle("点赞", for: .normal)
            }
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

        picCollectionView.register(UINib.init(nibName: "ItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCellId")
//        picCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCellId")
        picCollectionView.dataSource = self
        picCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            layout.itemSize = CGSize(width: 0.1, height: 0.1)
            picBottom.constant = 0
            return CGSize.zero
        }

        picBottom.constant = 10
        if count == 1 {
            let str = self.HomeViewModel!.picUrls.last!
            let image = SDImageCache.shared.imageFromDiskCache(forKey: str)
            if image != nil {
                let size =  CGSize.init(width: (image!.size.width) * 2, height: (image!.size.height) * 2)
                //布局picview
                layout.itemSize = size
                return size
            }
        }
        
        //布局picview
        let imageWH = (kScreenWidth - edgeMargin.floatValue * 2 -  itemMargin.floatValue * 2) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        layout.minimumLineSpacing = itemMargin.floatValue
        layout.minimumInteritemSpacing = itemMargin.floatValue
        
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
// MARK: - cell的图片collectionview的代理方法

extension HomeCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.HomeViewModel?.picUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCellId", for: indexPath) as! ItemCell
        guard let ImageUrl = self.HomeViewModel?.picUrls[indexPath.row] else {
            return cell
        }
        cell.backImg.sd_setImage(with: URL.init(string: ImageUrl), completed: nil)
        return cell
    }
    
}
class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var backImg: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
