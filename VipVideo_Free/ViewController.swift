//
//  ViewController.swift
//  VipVideo_Free
//
//  Created by zcy on 2018/4/19.
//  Copyright © 2018年 CY. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   private var modelsArray: Array = [VipUrlItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "视频"
        let myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CELLID")
        self.view.addSubview(myTableView)
//        let manage =
//        manage.initDefaultData()
        self.modelsArray = VipURLManager.sharedInstance.platformItemsArray
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELLID")!
        let item = self.modelsArray[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vipVC = VipVideoController()
        vipVC.urlItem = self.modelsArray[indexPath.row] 
        self.navigationController?.pushViewController(vipVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

