//
//  NN_Search_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 7/24/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class NN_Search_ViewController: UIViewController, UITextFieldDelegate {

     var dataList: NSMutableArray!
        
        let refreshControl = UIRefreshControl()
         
        var pageIndex: Int = 1
          
        var totalPage: Int = 1
          
        var isLoadMore: Bool = false
    
        @IBOutlet var topTitle: UILabel!
        
        @objc var isHidden: Bool = false
        
        @objc var cateId: String = ""
        
        @IBOutlet var tableView: UITableView!
    
        @IBOutlet var search: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
                            
            dataList = NSMutableArray.init()

            tableView.withCell("NN_Cell")
            
            tableView.withCell("NN_Cell_Detail")
                                   
            tableView.refreshControl = refreshControl
                   
            refreshControl.addTarget(self, action: #selector(didReload(_:)), for: .valueChanged)
            
//            self.didReload(refreshControl)
            
            search.addTarget(self, action: #selector(searchTextChange), for: .editingChanged)
        }
        
        @objc func searchTextChange(_ textField:UITextField) {
//           let hasText = textField.text?.replacingOccurrences(of: " ", with: "") == ""
       }
    
        @objc func didReload(_ sender: Any) {
            isLoadMore = false
            pageIndex = 1
            totalPage = 1
            didRequestData(isShow: true)
        }
        
        func didRequestData(isShow: Bool) {
            if (!search.hasText) {
                self.refreshControl.endRefreshing()
                return
            }
            let request = NSMutableDictionary.init(dictionary: ["CMD_CODE":"getNewsByKeyword",
                                                                "session":Information.token ?? "",
                                                                "keyword": search.text ?? "",
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
                
                self.topTitle.alpha = self.dataList.count != 0 ? 1 : 0
                
                self.tableView.reloadData()
            })
        }
        
        @IBAction func didPressBack() {
            self.navigationController?.popViewController(animated: true)
        }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             search.resignFirstResponder()
             if (textField.hasText) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    self.tableView.setContentOffset(.zero, animated: false)
                })
                self.didReload(self.refreshControl)
             }
             return true
        }
    }

    extension NN_Search_ViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension // 300
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row != 0 ? "NN_Cell_Detail" : "NN_Cell", for: indexPath)
            
            let data = dataList[indexPath.row] as! NSDictionary

            (self.withView(cell, tag: 111) as! UIView).withBorder(["Bwidth": 0, "Bcorner": 6])

            (self.withView(cell, tag: 11) as! UIImageView).imageUrl(url: data.getValueFromKey("thumbnail"))
            
//            (self.withView(cell, tag: 11) as! UIImageView).heightConstaint?.constant = indexPath.row == 0 ? 197 : 0
            
            (self.withView(cell, tag: 12) as! UILabel).text = data.getValueFromKey("title")
                
            (self.withView(cell, tag: 14) as! UILabel).text = data.getValueFromKey("date")

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
