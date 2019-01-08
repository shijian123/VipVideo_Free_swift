//
//  VipURLManager.swift
//  VipVideo_Free
//
//  Created by zcy on 2018/4/20.
//  Copyright © 2018年 CY. All rights reserved.
//

import Foundation

let  CYVipVideoDidChangeCurrentApi = "CYVipVideoDidChangeCurrentApi"

struct VipUrlItem {
    let title: String
    let url: String
}

struct VipURLManager {
    var itemsArray: Array<VipUrlItem> = []
    var platformItemsArray: Array<VipUrlItem> = []
    var currentVipApi: String = ""
    
    static var sharedInstance = VipURLManager()
    init() {
        self.initDefaultData()
    }
//    static let singleDefault = VipURLManager(itemsArray: [], platformItemsArray: [])
//
//    init(itemsArray: Array<VipUrlItem>, platformItemsArray: Array<VipUrlItem>) {
//        self.itemsArray = itemsArray
//        self.platformItemsArray = platformItemsArray
//        self.initDefaultData()
//    }
    
    public mutating func initDefaultData() -> Void {
        let path: String = Bundle.main.path(forResource: "viplist_new", ofType: "json")!
        
        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//        print("json:%@",dict)
        self.transformJsonToModel(dict as! NSDictionary)
        
    }
    
    mutating func transformJsonToModel(_ dict: NSDictionary) -> Void {
        let platformArray = NSMutableArray(array: dict["platformlist"] as! NSArray) as! [Dictionary<String, Any>]
        let urlsArray = NSMutableArray(array: dict["list"] as! NSArray) as! [Dictionary<String, Any>]
        itemsArray.removeAll()
        platformItemsArray.removeAll()
        for dic in platformArray {
            let item = VipUrlItem(title: dic["name"] as! String, url: dic["url"] as! String)
            platformItemsArray.append(item)
        }
        
        for dic in urlsArray {
            let item = VipUrlItem(title: dic["name"] as! String, url: dic["url"] as! String)
            itemsArray.append(item)
        }
        
        
        
    }
 
}
