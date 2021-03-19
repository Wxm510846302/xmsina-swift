//
//  ComposePicCollotionView.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/18.
//

import UIKit
import RxSwift
let picEdgeMargin = 10.0
let picPicerCellId = "picPickerCell"
class ComposePicCollotionView: UICollectionView, UICollectionViewDataSource {
    
    var closeBtnClick:((_ index:IndexPath)->(Void))? = nil
    var picImages:[UIImage] = [UIImage]() {
        didSet {
            if picImages.count < 9 {
                picImages.append(UIImage.init(named: "compose_picadd_cellbg")!)
            }
            self.reloadData()
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        picImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPicerCellId, for: indexPath) as! picPickerCell
        cell.backImg.image = picImages[indexPath.row]
        if indexPath.item != picImages.count - 1 {
            cell.closeBtn.isHidden = false
        }else {
            if picImages.count == 9 {
                cell.closeBtn.isHidden = false
            }else{
                cell.closeBtn.isHidden = true
            }
        }
        return cell
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (kScreenWidth -  4.0 * picEdgeMargin.floatValue) / 3
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = picEdgeMargin.floatValue
        layout.minimumInteritemSpacing = picEdgeMargin.floatValue
        register(UINib.init(nibName: "picPickerCell", bundle: nil), forCellWithReuseIdentifier:picPicerCellId)
        contentInset = UIEdgeInsets(top: picEdgeMargin.floatValue, left: picEdgeMargin.floatValue, bottom: 0, right: picEdgeMargin.floatValue)
    }
    deinit {
        print("ComposePicCollotionView deinit")
    }
    
    @objc func closeClick(_ index:IndexPath){
        print(index)
    }
}

class picPickerCell: UICollectionViewCell {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func closeClick() {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "deletePic"), object: backImg.image)
    }
}
