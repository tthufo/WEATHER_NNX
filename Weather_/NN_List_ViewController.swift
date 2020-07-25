//
//  NN_List_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 7/22/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class NN_List_ViewController: UIViewController {

    var dataList: NSMutableArray!
    
    let refreshControl = UIRefreshControl()
     
    var pageIndex: Int = 1
      
    var totalPage: Int = 1
      
    var isLoadMore: Bool = false
    
    @objc var isHidden: Bool = false
    
    @objc var cateId: String = ""
    
    @objc var titleText: String = ""
    
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var topHeight: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
            
        dataList = NSMutableArray.init()

        tableView.withCell("NN_Cell")
                               
        tableView.refreshControl = refreshControl
               
        refreshControl.addTarget(self, action: #selector(didReload(_:)), for: .valueChanged)
        
        self.didReload(refreshControl)
        
        topHeight.constant = isHidden ? 0 : 64
    }
    
    @objc func didReload(_ sender: Any) {
        isLoadMore = false
        pageIndex = 1
        totalPage = 1
        didRequestData(isShow: true)
    }
    
    func didRequestData(isShow: Bool) {
        let request = NSMutableDictionary.init(dictionary: ["CMD_CODE":"getNewsByCategory",
                                                            "session":Information.token ?? "",
                                                            "categoryId": cateId,
                                                            "pageIndex": pageIndex,
                                                            "overrideAlert":"1",
                                                            "overrideLoading":isShow ? 1 : 0,
                                                            "host":self])
        LTRequest.sharedInstance()?.didRequestInfo((request as! [AnyHashable : Any]), withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            self.refreshControl.endRefreshing()
            let result = response?.dictionize() ?? [:]
            
            if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
                return
            }
                        
            self.totalPage = (result["RESULT"] as! NSDictionary)["totalPage"] as! Int

            self.pageIndex += 1

            if !self.isLoadMore {
                self.dataList.removeAllObjects()
            }
            
            print("======", response)

            let data = ((result["RESULT"] as! NSDictionary)["data"] as! NSArray)
//
            self.dataList.addObjects(from: data.withMutable())
            
            self.tableView.reloadData()
        })
    }
    
    @IBAction func didPressMenu() {
        self.root()?.toggleLeftPanel(nil)
        (self.left() as! TG_Intro_ViewController).reloadLogin()
    }
    
    @IBAction func didPressSearch() {
        self.center().pushViewController(NN_Search_ViewController.init(), animated: true)
    }
}

extension NN_List_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NN_Cell", for: indexPath)
        
        let data = dataList[indexPath.row] as! NSDictionary

        (self.withView(cell, tag: 10) as! UIView).withShadow()

        (self.withView(cell, tag: 11) as! UIImageView).imageUrl(url: data.getValueFromKey("thumbnail"))
        
        (self.withView(cell, tag: 12) as! UILabel).text = data.getValueFromKey("title")
            
        (self.withView(cell, tag: 14) as! UILabel).text = data.getValueFromKey("date")

        (self.withView(cell, tag: 190) as! UIImageView).isHidden = (data.getValueFromKey("content")?.contains(find: "wp-video"))! ? false : true

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList[indexPath.row] as! NSDictionary

        let n = NN_Detail_ViewController.init()
        
        n.object = data
        
        self.center().pushViewController(n, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count - 1 {
          if self.pageIndex <= self.totalPage {
              self.isLoadMore = true
              self.didRequestData(isShow: false)
          }
       }
    }
}
