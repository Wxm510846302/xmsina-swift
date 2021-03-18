//
//  HomeTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
// 

import UIKit
import AutoInch
import HandyJSON
import SDWebImage
import MJRefresh
import SwiftyJSON
class HomeTableCtr: XMBaseTableCtr {
    
    var HomePageModels:[HomeModelTool] = [HomeModelTool]()
    lazy var refreshMsgLabel:UILabel = UILabel.init().then {
        $0.frame = CGRect.init(x: 0, y: navigationController!.navigationBar.height() - 30, width: kScreenWidth, height: 30)
        $0.backgroundColor = .systemOrange
        $0.font = UIFont.systemFont(ofSize: 13.auto())
        $0.textColor = .white
        $0.text = "有1条新微博"
        $0.textAlignment = .center
        $0.isHidden = true
        navigationController?.navigationBar.insertSubview($0, at: 0)
        // MARK: - 这个是保证提示框在navigationbar底下的关键  zPosition
        $0.layer.zPosition = -1
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.badgeValue = "3"
       
        if !self.isLogin {
            //如果没有登录，那么就创建访客视图
            self.visitorView.setupVistorUI(backImg: "tabbar_home", msg: "首页访客视图")
        }else{
            setUpNavgationItems()
            //注册cell
            tableView?.register(UINib.init(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCellId")
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 200
            // MARK: - 先加载缓存数据，再刷新
            
            self.setUpRefrsh()
        }
        
//        print(
//            "this is " +
//                "default".screen
//                .width(._320, is: "宽度 320")
//                .width(._375, is: "宽度 375")
//                .height(._844, is: "高度 844")
//                .height(._812, is: "高度 812")
//                .inch(._4_7, is: "4.7 英寸")
//                .inch(._5_8, is: "5.8 英寸")
//                .inch(._6_5, is: "6.5 英寸")
//                .level(.compact, is: "屏幕级别 紧凑屏")
//                .level(.regular, is: "屏幕级别 常规屏")
//                .level(.full, is: "屏幕级别 全面屏")
//                .value
//        )
//        print(0.screen.level(.full, is: 1).inch(._6_1, is: 2).level(.compact, is: 0).value)
//        print("当前屏幕级别: \(Screen.Level.current)")
//        print("是否为全面屏: \(Screen.isFull)")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func loadView() {
        super.loadView()
        //首先先加载本地数据
        HomePageModels = HomeCore.init().queryData()
    }

    func TabBarDidClick() {
    
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        //刷新
        tableView.mj_header?.beginRefreshing()
    }
}
// MARK: - 设置UI

extension HomeTableCtr {
    //设置导航条
    private func setUpNavgationItems()  {
        //下面两个有点区别，第一个自定义的是button，可以设置高亮image
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "navigationbar_friendsearch")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendsearch"), style: .done, target: self, action: #selector(self.friendClick))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: "navigationbar_pop"),UIBarButtonItem(image: "navigationbar_redbag")]
        let friend = navigationItem.leftBarButtonItems?.first?.customView as? UIButton
        let pop = navigationItem.rightBarButtonItems?.first?.customView as? UIButton
        let redbag = navigationItem.rightBarButtonItems?.last?.customView as? UIButton
        pop?.addTarget(self, action: #selector(self.popClick), for: .touchUpInside)
        redbag?.addTarget(self, action: #selector(self.redbagClick), for: .touchUpInside)
        friend?.addTarget(self, action: #selector(self.friendClick), for: .touchUpInside)
    }
    private func setUpRefrsh(){
        let refreshHeader = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.hederRefresh))
        self.tableView.mj_header = refreshHeader
        self.tableView.mj_header!.beginRefreshing()
        
        let refreshFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.hederRefresh))
        refreshFooter.triggerAutomaticallyRefreshPercent = 0.1
        self.tableView.mj_footer = refreshFooter
    }
    private func showNewMessageLb(countNumber:Int){
        self.refreshMsgLabel.text = "有\(countNumber)条新微博"
        if self.refreshMsgLabel.isHidden == true {
            //防止出现动画重叠问题
            self.refreshMsgLabel.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.refreshMsgLabel.frame.origin.y = self.navigationController?.navigationBar.frame.size.height ?? 0
            } completion: { (_) in
                UIView.animate(withDuration: 0.5, delay: 1.5, options: []) {
                    self.refreshMsgLabel.bottom(self.navigationController!.navigationBar.height())
                } completion: { (_) in
                    self.refreshMsgLabel.layer.isHidden = true
                    self.refreshMsgLabel.isHidden = true
                }

            }
        }
        

    }
   
}
// MARK: - 监听点击事件

extension HomeTableCtr{
    
    @objc func popClick(){
        XMLog("popClick")
    }
    @objc func redbagClick(){
        XMLog("redbagClick")
    }
    @objc func friendClick(){
        XMLog("friendClick")
    }
    @objc func zhuanfaClick(){
        XMLog("zhuanfaClick")
    }
    @objc func hederRefresh(){
        self.getDataFromHomeUrl()
    }
}
// MARK: - 代理方法

extension HomeTableCtr{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.HomePageModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellId") as? HomeCell
        if cell == nil {
            cell = HomeCell.init(style: .default, reuseIdentifier: "HomeCellId")
        }
        if  self.HomePageModels.count > 0 {
            cell!.index = indexPath
            cell!.HomeViewModel = self.HomePageModels[indexPath.row]
            cell!.zhuanfa.addTarget(self, action: #selector(self.zhuanfaClick), for: .touchUpInside)
        }
        
        return cell!
    }
}

// MARK: - 网络相关

extension HomeTableCtr {
    
    func getDataFromHomeUrl(){
        var since_id = 0,max_id = 0
        if self.tableView.mj_header?.isRefreshing == true{
            //下拉刷新
            since_id = self.HomePageModels.first?.homeModel?.mid ?? 0
        }
        else if self.tableView.mj_footer?.isRefreshing == true {
            //上拉加载
            max_id = self.HomePageModels.last?.homeModel?.mid ?? 0
            max_id = (max_id == 0 ? 0:(max_id - 1))//防止重复最后一条数据
        }
       
        xmProvider.request(.getHomePageData(access_token: UserCountManager.userModel!.access_token!,since_id: since_id,max_id: max_id)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                guard let jsonDic = try? JSON(data: data) else {
                    return
                }
                let tempArr = jsonDic["statuses"].arrayValue
                var tempModels:Array<HomeModelTool> = []
                for statuses in tempArr {
                    // MARK76  : - 由于是model里嵌套model ---》user 所以要使用dictionaryObject方法而不能使用dictionaryValue(返回的是‘JSON’格式)
                    let homemodel = HomeModel.deserialize(from: statuses.dictionaryObject)
                    let homeModelTool = HomeModelTool.init(homeModel: homemodel!)
                    tempModels.append(homeModelTool)
                }
                if self.tableView.mj_header?.isRefreshing == true {
                    self.HomePageModels = tempModels + self.HomePageModels
                    self.tableView.mj_header?.endRefreshing()
                    //加载提示
                    self.showNewMessageLb(countNumber: tempModels.count)
                }
                else if self.tableView.mj_footer?.isRefreshing == true {
                    self.HomePageModels = self.HomePageModels + tempModels
                    self.tableView.mj_footer?.endRefreshing()
                }
                //缓存图片
                self.cacheImages(viewModels: self.HomePageModels)
               //保存到coredata
                HomeCore.init().modifyData(self.HomePageModels)
                
            case .failure(_): break
                
            }
        }
    }
    private func cacheImages(viewModels:[HomeModelTool]){
        let group = DispatchGroup.init()
        for HomeView in viewModels {
            for imageString in HomeView.picUrls {
                group.enter()
                SDWebImageManager.shared.loadImage(with: URL.init(string: imageString), options: [], progress: nil) { (_, _, _, _, _, _) in
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
}
