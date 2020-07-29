//
//  First_Tab_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 4/8/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MessageUI

import MarqueeLabel

class PC_Weather_Main_ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var tableView: OwnTableView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var coverView: UIImageView!

    @IBOutlet var titleLabel: MarqueeLabel!
    
    @IBOutlet var back: UIButton!
    
    @IBOutlet var search: UIButton!

    var customLat: String!
    
    var customLng: String!
    
    var customLocation: String!

    var config: NSArray!
    
    var dataList: NSMutableArray!
    
    var weatherData: NSMutableDictionary!
    
    let refreshControl = UIRefreshControl()
    
    var registered: Bool = false

    func check() -> Bool {
        return Information.check == "0"
    }
    
    func reloadState() {
        self.bottomView.isHidden = check() ? true : logged() && registered ? true : false
        
        (self.withView(self.bottomView, tag: 11) as! UIButton).isHidden = logged() ? registered ? false : true : false
        (self.withView(self.bottomView, tag: 12) as! UIButton).isHidden = logged() ? registered ? false : true : false
        
        (self.withView(self.bottomView, tag: 1) as! UILabel).text = logged() ? "Để sử dụng đầy đủ chức năng của ứng dụng, Quý khách cần đăng ký dịch vụ. Để kích hoạt dịch vụ, soạn tin DKN gửi 1595." : "Để xem thông tin chi tiết mời quý khách đăng nhập để sử dụng."
        
        self.tableView.isScrollEnabled = logged() && registered
        
        if check() {
            self.tableView.isScrollEnabled = true
        }
        
//        self.bg.image = UIImage.init(named: logged() && registered ? "bg-2" : "bg_sunny_day")
        
        self.tableView.reloadData(withAnimation: true)
        
        print(logged(), registered)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        bottomView.isHidden = true
 
        if !logged() {
            self.reloadState()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.didRequestPackage()
            })
        }
        
        self.getAddressFromLatLon(pdblLatitude: self.customLat != nil ? self.customLat : self.lat(), pdblLongitude: self.customLng != nil ? self.customLng : self.lng())
    }
    
    func location() {
        Permission.shareInstance()?.initLocation(false, andCompletion: { (type) in
            switch type {
            case .lAlways:
                self.getAddressFromLatLon(pdblLatitude: self.customLat != nil ? self.customLat : self.lat(), pdblLongitude: self.customLng != nil ? self.customLng : self.lng())
                break
            case .lDenied:
                break
            case .lDisabled:
               break
            case .lWhenUse:
                self.getAddressFromLatLon(pdblLatitude: self.customLat != nil ? self.customLat : self.lat(), pdblLongitude: self.customLng != nil ? self.customLng : self.lng())
               break
            case .lRestricted:
               break
            case .lNotSure:
               break
            default:
                break
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.customLat != nil && self.customLng != nil {
            back.setImage(UIImage.init(named: "icon_back"), for: .normal)
            search.alpha = 0
            self.didGetWeather(loading: false)
            self.coverView.alpha = 0
            self.titleLabel.text = self.customLocation
        } else {
            let login = self.loginNav(type: "logIn") { (info) in
    //            if self.coverView.alpha == 0 {
    //                self.didRequestPackage()
                self.didGetWeather(loading: false)
    //            }
                self.coverView.alpha = 0
            }
            
            self.center()?.present(login, animated: false, completion: nil)
            
//            location()
        }
        location()

        weatherData = NSMutableDictionary.init()
        
        tableView.withCell("PC_Weather_Cell")
        
        tableView.withCell("PC_Week_Cell")

        tableView.withCell("PC_Day_Cell")

        tableView.withCell("PC_Rain_Cell")

        tableView.withCell("PC_Wind_Cell")

        tableView.withCell("TG_Room_Cell_Banner_1")

        tableView.withCell("TG_Room_Cell_0")

        tableView.withCell("TG_Room_Cell_1")

        tableView.withCell("TG_Room_Cell_2")

        tableView.withCell("TG_Room_Cell_3")

        tableView.withCell("TG_Room_Cell_4")

        tableView.withCell("TG_Room_Cell_5")
                
        tableView.withCell("TG_Room_Cell_6")

        tableView.withCell("TG_Room_Cell_7")

        tableView.withCell("TG_Room_Cell_8")
                
        tableView.withCell("TG_Room_Cell_9")

        tableView.withCell("TG_Room_Cell_10")
        
        dataList = NSMutableArray.init()
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didReload), for: .valueChanged)
        
        config = NSArray.init(array: [["url": ["CMD_CODE":"getHomeEvent",
                                               "page_index": 1,
                                               "page_size": 24,
                                               "position": 1,
            ], "height": 455, "loaded": false, "ident": "PC_Weather_Cell"],
                                      
                                      
                                      
                                      ["title":"Miễn phí HOT",
                                       "url": ["CMD_CODE":"getListBook",
                                           "page_index": 1,
                                           "page_size": 24,
                                           "book_type": 0,
                                           "price": 2,
                                           "sorting": 1,
                                       ], "height": 276, "direction": "horizontal", "loaded": false, "ident": "PC_Week_Cell"],
                                      
                                      
                                      ["title":"Mới nhất",
                                        "url": ["CMD_CODE":"getListBook",
                                           "page_index": 1,
                                           "page_size": 24,
                                           "book_type": 2,
                                           "price": 0,
                                           "sorting": 1,
                                         ], "height": ((self.screenWidth() / 3) * 2) + 0, "direction": "horizontal", "loaded": false, "ident": "PC_Day_Cell"],
                                      
                                      
                                      
                                      
                                      ["title":"Đọc nhiều nhất",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 0,
                                          "price": 0,
                                          "sorting": 1,
                                      ], "height": 240, "direction": "vertical", "loaded": false, "ident": "PC_Rain_Cell"],
                                      
                                      
                                      ["title":"Sách nói",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 3,
                                          "price": 0,
                                          "sorting": 1,
                                      ], "height": 350, "direction": "horizontal", "loaded": false, "ident": "PC_Wind_Cell"],
                                      
                                      
                                      
                                      ["title":"Khuyên nên đọc",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 0,
                                          "price": 0,
                                          "sorting": 3,
                                      ], "height": 0, "direction": "vertical", "loaded": false],
                                      
                                      
                                      
                                      ["url": ["CMD_CODE":"getHomeEvent",
                                               "page_index": 1,
                                               "page_size": 24,
                                               "position": 2,
                                      ], "height": 0, "loaded": false, "ident": "TG_Room_Cell_Banner_1"],
                                      
                                      
                                      
                                      
                                      ["title":"Promotion",
                                        "url": ["CMD_CODE":"getListPromotionBook",
                                           "page_index": 1,
                                           "page_size": 24,
                                         ], "height": 0, "direction": "horizontal", "loaded": false],
        ]).withMutable() as NSArray?
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            //self.didReload()
        })
        
//        didGetWeather()
        
//        location()
    }
    
    func didGetWeather(loading: Bool = false) {
        if loading {
           self.showSVHUD("", andOption: 0)
        }
       LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"getWeatherOfLocation",
                                                   "lat": self.customLat != nil ? self.customLat : self.lat(),
                                                   "long": self.customLng != nil ? self.customLng : self.lng(),
                                                   "overrideAlert":"1",
//                                                   "overrideLoading":"1",
//                                                   "host":self
        ], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
        
           let result = response?.dictionize() ?? [:]
           self.refreshControl.endRefreshing()
           self.hideSVHUD()
                
           if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
               self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
               return
           }
                  
           self.weatherData.removeAllObjects()
        
           self.weatherData.addEntries(from: (result["RESULT"] as! NSDictionary) as! [AnyHashable : Any])
        
           self.tableView.reloadData(withAnimation: true)

        UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 1
        }
        
           self.didRequestPackage()
       })
        
        self.getAddressFromLatLon(pdblLatitude: self.customLat != nil ? self.customLat : self.lat(), pdblLongitude: self.customLng != nil ? self.customLng : self.lng())
   }
    
    @objc func didReload() {
        didGetWeather(loading: true)
        for dict in self.config {
            (dict as! NSMutableDictionary)["loaded"] = false
        }
//        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func didPressMenu() {
        if self.customLat != nil && self.customLng != nil {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.root()?.toggleLeftPanel(nil)
        (self.left() as! TG_Intro_ViewController).reloadLogin()
    }
    
    @IBAction func didPressSearch() {
        if logged() {
            if check() {
                self.center()?.pushViewController(PC_Search_Weather_ViewController.init(), animated: true)
            } else {
                self.didGetPackage(showMenu: true)
            }
        } else {
            let login = self.loginNav(type: "logOut") { (info) in
                self.didRequestPackage()
            }
            self.center()?.present(login, animated: true, completion: nil)
        }
    }
    
    func didRequestPackage() {
        if !logged() {
            return
        }
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"getPackageInfo",
                                                    "session":Information.token ?? "",
                                                    "deviceId":self.deviceUUID() ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1"
                                                    ], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]

            if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
               self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
               return
            }

            self.registered = self.checkRegister(package: response?.dictionize()["RESULT"] as! NSArray)

            self.reloadState()
        })
    }
    
    func checkRegister(package: NSArray) -> Bool {
      var isReg = false /// debug mode -> true
      for dict in package {
          let expDate = ((dict as! NSDictionary).getValueFromKey("expireTime")! as NSString).date(withFormat: "dd/MM/yyyy")
          if (dict as! NSDictionary).getValueFromKey("status") == "1" && expDate! > Date() {
              isReg = true
              break
          }
      }
        
      return isReg
    }
    
    func didGetPackage(showMenu: Bool) {
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"getPackageInfo",
                                                    "session": Information.token ?? "",
                                                    "deviceId":self.deviceUUID() ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1"
                                                    ], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                          
            if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
                return
            }
                    
            let info = ((result["RESULT"] as! NSArray)[0] as! NSDictionary)
                        
            if showMenu {
                self.registered = self.checkRegister(package: response?.dictionize()["RESULT"] as! NSArray)

                if self.registered {
                    self.center()?.pushViewController(PC_Search_Weather_ViewController.init(), animated: true)
                } else {
                    EM_MenuView.init(package: (info as! [AnyHashable : Any])).show { (index, objc, menu) in
                        if index == 0 {
                            let data = (objc as! NSDictionary)
                            if (MFMessageComposeViewController.canSendText()) {
                                 let controller = MFMessageComposeViewController()
                                 controller.body = data.getValueFromKey("reg_keyword")
                                 controller.recipients = [data.getValueFromKey("reg_shortcode")]
                                 controller.messageComposeDelegate = self
                                 self.present(controller, animated: true, completion: nil)
                             }
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func didPressLogin() {
        let login = self.loginNav(type: "logOut") { (info) in
            self.didRequestPackage()
        }
        self.center()?.present(login, animated: true, completion: nil)
    }
    
    @IBAction func didPressRegister() {
//        EM_MenuView.init(packageShow: ["info": "Để đăng ký tài khoản, soạn tin nhắn MK gửi 1095."]).show { (index, objc, menu) in
//      }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "DKN"
            controller.recipients = ["1595"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension PC_Weather_Main_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (config![indexPath.row] as! NSDictionary)["height"] as! CGFloat
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return check() ? 5 : !logged() || !registered ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conf = config[indexPath.row] as! NSMutableDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: conf.getValueFromKey("ident") != "" ? conf.getValueFromKey("ident") : "TG_Room_Cell_%i".format(parameters: indexPath.row) , for: indexPath)
        
        if indexPath.row == 0 {
            (cell as! PC_Weather_Cell).data = self.weatherData as NSDictionary
            (cell as! PC_Weather_Cell).chartState(check() ? true : registered)
        }
        
        if indexPath.row == 1 {
           (cell as! PC_Week_Cell).data = self.weatherData as NSDictionary
           (cell as! PC_Week_Cell).didReloadData()
            
//            let last = self.withView(cell, tag: 99) as! UIView
//            last.setGradientBackground(colorTop: .clear, colorBottom: .white)
//            self.weekCell(cell: cell)
        }
        
        if indexPath.row == 2 {
            (cell as! PC_Day_Cell).data = self.weatherData as NSDictionary
            (cell as! PC_Day_Cell).didReloadData()
        }
        
        if indexPath.row == 3 {
            (cell as! PC_Rain_Cell).data = self.weatherData as NSDictionary
            (cell as! PC_Rain_Cell).didReloadData()
        }
        
        if indexPath.row == 4 {
            (cell as! PC_Wind_Cell).data = self.weatherData as NSDictionary
        }
        
        return cell
    }
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        if !self.isConnectionAvailable() {
            return
        }
        
        if pdblLatitude == "0" && pdblLongitude == "0"{
            self.titleLabel.text = "Nhà Nông Xanh"
            return
        }
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("+++++====>reverse geodcode fail: \(error!.localizedDescription)")
                    
                    self.titleLabel.text = "Nhà Nông Xanh"

                    return
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                                       addressString = addressString + pm.thoroughfare! + ", "
                                   }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
               
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ""
                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }

                    print(addressString)
                    
                    self.titleLabel.text = addressString
              }
        })

    }
    
    @objc func dayCell() -> NSMutableArray {
        if !self.weatherData.response(forKey: "currently") {
            return NSMutableArray.init()
        }
        let currently = (self.weatherData as NSDictionary)["currently"] as! NSDictionary
        
        let keys = [
            ["key":"humidity", "tag": 3, "unit": "%", "img": "ico_humidity_2"],
            ["key":"uvIndex", "tag": 8, "unit": "UV", "img": "ico_uv"],
            ["key":"windSpeed", "tag": 4, "unit": "km/h", "img":"ico_wind_2"],
            ["key":"precipIntensity", "tag": 1, "unit": "mm", "img":"ico_rain"],
            ["key":"dewPoint", "tag": 2, "unit": "°", "img":"ico_dewpoint"],
            ["key":"pressure", "tag": 6, "unit": "mb", "img":"ico_pressure"],
//                    ["key":"windGust", "tag": 5, "unit": "km/h"],
//                    ["key":"windBearing", "tag": 7, "unit": ""],
            ]
        
        let arr = NSMutableArray.init()
        
//        for view in cell.contentView.subviews {
            for key in keys {
//                if view.tag == key["tag"] as! Int + 9 {
                arr.add(["val": currently.getValueFromKey((key["key"] as! String)), "unit": (key["unit"] as! String), "img": key["img"]])
//                    (view as! UILabel).text = self.returnValCurrent(currently.getValueFromKey((key["key"] as! String)), unit: (key["unit"] as! String))
//                }
            }
//        }
        
        print("++++", arr)
        
        return arr
    }
    
    func weekCell(cell: UITableViewCell) {
        if !self.weatherData.response(forKey: "daily") {
            return
        }
        let daily = (self.weatherData as NSDictionary)["daily"] as! NSArray
        let keys = ["temperatureHigh", "temperatureLow", "icon", "humidity", "time"]
        var index = 0
        for view in (self.withView(cell, tag: 11) as! UIStackView).subviews {
            var indexing = 0
            for subView in view.subviews {
                let tempa = (daily[index] as! NSDictionary).getValueFromKey(keys[indexing])
                if subView is UILabel {
                    (subView as! UILabel).text = indexing == 4 ? self.returnDate(tempa) : self.returnVal(tempa, unit: indexing == 3 ? "%" : "°")
                } else {
                    (subView as! UIImageView).image = UIImage.init(named: tempa!.replacingOccurrences(of: "-", with: "_"))
                }
                indexing += 1
            }
            index += 1
        }
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
