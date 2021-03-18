//
//  HomeCore.swift
//  sinaDemo
//
//  Created by Xueming on 2021/3/18.
//

import UIKit
import CoreData
import SwiftyJSON
import HandyJSON
class HomeCore: NSObject {
    //获取管理的数据上下文 对象
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    /// 保存数据
    func addData(_ objc:[HomeModelTool])
    {
        //只保存前100个
        var saveLastArr = objc
        if objc.count >= 100 {
            saveLastArr = Array(objc[...99])
        }
        //将含有【HomeModelTool】的数组转换成字符串类型的数组，然后才能保存到coredata中
        var tempArr:[String] = [String]()
        for item:HomeModelTool in saveLastArr {
            tempArr.append(item.toJSONString()!)
        }
        
        //创建User对象
        let homeCore = NSEntityDescription.insertNewObject(forEntityName: "Home",
                                                       into: context) as! Home

        //对象赋值
        homeCore.homeTools = tempArr as NSObject

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
        let fetchRequest = NSFetchRequest<Home>(entityName:"Home")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
//        let predicate = NSPredicate(format: "id= '1' ", "")
//        fetchRequest.predicate = predicate

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
    func modifyData(_ newObjc:[HomeModelTool])
    {
        //只保存前100个
        var newSaveLastArr = newObjc
        if newObjc.count >= 100 {
            newSaveLastArr = Array(newObjc[...99])
        }
        //声明数据的请求
        let fetchRequest = NSFetchRequest<Home>(entityName:"Home")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
//        let predicate = NSPredicate(format: "id= '1' ", "")
//        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            if fetchedObjects.count == 0 {
                //没有就保存起来
                self.addData(newSaveLastArr)
            }else{
                //将含有【HomeModelTool】的数组转换成字符串类型的数组，然后才能保存到coredata中
                var tempArr:[String] = [String]()
                for item:HomeModelTool in newSaveLastArr {
                    tempArr.append(item.toJSONString()!)
                }
                //遍历查询的结果
                for info in fetchedObjects{
                    //修改密码
                    info.homeTools = tempArr as NSObject
                    //重新保存
                    try context.save()
                }
                print("修改成功！")
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }
    /// 查询数据
    func queryData()->[HomeModelTool]
    {
        var objc:[HomeModelTool] = [HomeModelTool]()
        
        //声明数据的请求
        let fetchRequest = NSFetchRequest<Home>(entityName:"Home")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        //设置查询条件
//        let predicate = NSPredicate(format: "id= '1' ", "")
//        fetchRequest.predicate = predicate

        //查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            if fetchedObjects.count > 0  {
                //遍历查询的结果
    //            for info in fetchedObjects{
    //                print("id=\(String(describing: info.homeTools))")
    //            }
                //对返回的结果进行model包装
                let tempJsonStringArr:[String] = fetchedObjects.last?.homeTools as! [String]
                for item in tempJsonStringArr {
                    guard let homeTool = HomeModelTool.deserialize(from: item) else { return objc }
                    objc.append(homeTool)
                }
            }

        }
        catch {
            fatalError("不能保存：\(error)")
        }
        return objc
    }
    private func CheackSaveArray(_ objc:[HomeModelTool]){
        var saveArr:[HomeModelTool] = [HomeModelTool]()
        saveArr = objc
        let lasetArr = saveArr[...2]
        print(type(of: lasetArr))
       
    }
}
