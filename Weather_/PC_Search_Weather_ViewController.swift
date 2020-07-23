//
//  PC_Search_Weather_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/15/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import SwipyCell

import LocationPickerViewController

class PC_Search_Weather_ViewController: UIViewController {

    var dataList: NSMutableArray!
    
    let refreshControl = UIRefreshControl()

    @IBOutlet var searchView: UIView!

    @IBOutlet weak var tableView: UITableView! {
          didSet {
              tableView.rowHeight = UITableView.automaticDimension
              tableView.estimatedRowHeight = 80.0
          }
      }
    
    @IBAction func didPressBack() {
       self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataList = NSMutableArray.init()
        
        tableView.withCell("PC_Notification_Cell")
        
        didGetLocation()
        
        searchView.action(forTouch: [:]) { (objc) in
            self.didPressLocation()
        }
        
        tableView.refreshControl = refreshControl
               
        refreshControl.addTarget(self, action: #selector(didReload), for: .valueChanged)
    }
    
    @objc func didReload() {
        self.didGetLocation()
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func didPressLocation() {
        let locationPicker = LocationPicker()
        locationPicker.preselectedIndex = 0
        locationPicker.pickCompletion = { (pickedLocationItem) in
            self.didAddLocation(lat: String(pickedLocationItem.mapItem.placemark.coordinate.latitude), lng: String(pickedLocationItem.mapItem.placemark.coordinate.longitude), name: pickedLocationItem.mapItem.name!)
        }
        locationPicker.addBarButtons()
//        locationPicker.setColors(themeColor: AVHexColor.color(withHexString: "#5530F5"), primaryTextColor: UIColor.black, secondaryTextColor: UIColor.darkGray)
        

        let navigationController = UINavigationController(rootViewController: locationPicker)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func didGetLocation() {
         LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getListFavouriteLocation",
                                                     "session":Information.token ?? "",
                                                     "overrideAlert":"1",
                                                     "overrideLoading":"1",
                                                     "host":self], withCache: { (cacheString) in
         }, andCompletion: { (response, errorCode, error, isValid, object) in
             let result = response?.dictionize() ?? [:]
             self.refreshControl.endRefreshing()

             if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                 self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                 return
             }
            
            self.dataList.removeAllObjects()
            
            self.dataList.addObjects(from: ((result["result"] as! NSArray) as! [Any]))
                                               
            self.tableView.reloadData()
      })
   }
    
    func didGetDeleteLocation(id: String) {
          LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"deleteFavouriteLocation",
                                                      "session":Information.token ?? "",
                                                      "id":id,
                                                      "overrideAlert":"1",
                                                      "overrideLoading":"1",
                                                      "host":self], withCache: { (cacheString) in
          }, andCompletion: { (response, errorCode, error, isValid, object) in
              let result = response?.dictionize() ?? [:]
                                                  
              if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                  self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                  return
              }

              self.showToast("Xóa địa điểm thành công", andPos: 0)
       })
    }
    
    func didAddLocation(lat: String, lng: String, name: String) {
          LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"addFavouriteLocation",
                                                      "session":Information.token ?? "",
                                                      "lat": lat,
                                                      "long": lng,
                                                      "name":name,
                                                      "overrideAlert":"1",
                                                      "overrideLoading":"1",
                                                      "host":self], withCache: { (cacheString) in
          }, andCompletion: { (response, errorCode, error, isValid, object) in
              let result = response?.dictionize() ?? [:]
                                                  
              if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                  self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                  return
              }

            self.didGetLocation()
            
            self.showToast("Thêm địa điểm thành công", andPos: 0)
       })
    }
}

extension PC_Search_Weather_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PC_Notification_Cell", for: indexPath) as! SwipyCell
        
        let data = dataList[indexPath.row] as! NSDictionary

        let weather = ((dataList[indexPath.row] as! NSDictionary)["weather"] as! NSDictionary)["currently"] as! NSDictionary

        let swipeView = viewWithImageName("ic_delete_all")
        let swipeColor = AVHexColor.color(withHexString: "#CCCCCD")
        
        (self.withView(cell, tag: 11) as! UILabel).text = (data["info"] as! NSDictionary).getValueFromKey("name")
            
        (self.withView(cell, tag: 12) as! UILabel).text = weather.getValueFromKey("temperature") + "°"

        (self.withView(cell, tag: 13) as! UIImageView).image = UIImage.init(named: (weather.getValueFromKey("icon")?.replacingOccurrences(of: "-", with: "_"))!)
                
        cell.addSwipeTrigger(forState: .state(0, .right), withMode: .exit, swipeView: swipeView, swipeColor: swipeColor!, completion: { cell, trigger, state, mode in
            self.dataList.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            self.didGetDeleteLocation(id: (data["info"] as! NSDictionary).getValueFromKey("id")!)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
