//
//  XMBaseTableCtr.swift
//  sinaDemo
//
//  Created by admin on 2021/3/1.
//

import UIKit

class XMBaseTableCtr: UITableViewController {
    //懒加载访客视图
    lazy var visitorView :XMBaseVistorView = XMBaseVistorView.visitorView()
    lazy var LoginBtn : UIButton = UIButton.init()
    //全局登录状态
    var isLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
  
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

extension XMBaseTableCtr
{
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    func setupVisitorView()  {
//        LoginBtn.frame.size = CGSize.init(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        self.view = visitorView
        visitorView.loginBtn.addTarget(self, action: #selector(self.loginClick), for: .touchUpInside)
        setNavgationItems()
    }
    //设置导航控制器左右按钮item
    func setNavgationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(self.registClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.loginClick))
    }
    @objc private func loginClick() {
        print("loginClick")
        let AutoCtr = AutoLoginCtr.init()
        let nav = UINavigationController.init(rootViewController: AutoCtr)
        present(nav, animated: true, completion: nil)
    }
    @objc private func registClick() {
        print("registClick")
    }
}
