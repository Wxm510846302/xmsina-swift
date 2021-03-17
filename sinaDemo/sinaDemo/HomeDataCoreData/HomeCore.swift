//
//  HomeCore.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/17.
//

import UIKit
import CoreData

class HomeCore: NSObject {
    //获取管理的数据上下文 对象
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override init() {
        super.init()
    }
    /// 添加数据
    func addData()
    {
        
        //创建User对象
        let user = NSEntityDescription.insertNewObject(forEntityName: "User",
                                                       into: context) as! User
        //对象赋值
        user.access_token = "woshitoken"

        
        let friend1 = UserCount()
        friend1.access_token = "小明"
  
        
        let friend2 = UserCount()
        friend2.access_token = "小黄"
        
        user.anyObject = [friend1, friend2] as NSObject
        
        //保存
        do {
            try context.save()
            print("保存成功！")
        } catch {
            fatalError("不能保存：\(error)")
        }
    }
    /// 删除数据操作
    func deleteData()
    {
       
        //声明数据的请求
        let fetchRequest = NSFetchRequest<User>(entityName:"User")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
        let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                //删除对象
                context.delete(info)
            }

            //重新保存-更新到数据库
            try! context.save()
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }
    /// 修改数据操作
    func modifyData()
    {
       
        //声明数据的请求
        let fetchRequest = NSFetchRequest<User>(entityName:"User")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
        let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                //修改密码
                info.access_token = "abcd"
                //重新保存
                try context.save()
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }

    /// 查询数据
    func queryData()
    {
        
        //声明数据的请求
        let fetchRequest = NSFetchRequest<User>(entityName:"User")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
        let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                print("id=\(String(describing: info.access_token))")
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }

}
