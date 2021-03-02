//
//  HomeTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/2/28.
// 

import UIKit

class HomeTableCtr: XMBaseTableCtr {
    
    lazy var titleView:XMRightImgBtn = XMRightImgBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.badgeValue = "3"
        
        self.visitorView.setupVistorUI(backImg: "tabbar_home", msg: "首页访客视图")
        
        setUpNavgationItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - 设置UI

extension HomeTableCtr {
    func setUpNavgationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: "navigationbar_pop")
        titleView.setTitle("wxm", for: .normal)
        titleView.addTarget(self, action: #selector(self.titleViewClick), for: .touchUpInside)
        navigationItem.titleView = titleView
    }
   
}
// MARK: - 监听点击事件

extension HomeTableCtr{
    @objc func titleViewClick() {
        self.titleView.isSelected = !self.titleView.isSelected
        let poVc = PopViewCtr.init()
        poVc.transitioningDelegate = self
        poVc.modalPresentationStyle = .custom
        self.present(poVc, animated: true, completion: nil)
    }
}
extension HomeTableCtr:UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopPresentationCtr(presentedViewController: presented, presenting: presenting)
    }
}
