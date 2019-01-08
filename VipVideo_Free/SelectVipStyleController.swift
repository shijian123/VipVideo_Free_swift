//
//  SelectVipStyleController.swift
//  VipVideo_Free
//
//  Created by zcy on 2018/4/20.
//  Copyright © 2018年 CY. All rights reserved.
//

import UIKit

class SelectVipStyleController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var dataArr: Array<VipUrlItem> {
        let arr: Array = VipURLManager.sharedInstance.itemsArray
        return arr
    }
    private var myTableView: UITableView {
        let tableV = UITableView(frame: self.view.frame, style: .plain)
        tableV.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CELLID")
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELLID")!
        let item = dataArr[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VipURLManager.sharedInstance.currentVipApi = dataArr[indexPath.row].url

        if strlen(VipURLManager.sharedInstance.currentVipApi) > 0 {
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .init(CYVipVideoDidChangeCurrentApi), object: nil)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
