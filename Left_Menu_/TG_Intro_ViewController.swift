//
//  TG_Intro_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/4/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

class TG_Intro_ViewController: UIViewController {
            
    @IBOutlet var tableView: UITableView!
        
    @IBOutlet var userName: UILabel!

    @IBOutlet var phoneNo: UILabel!
    
    @IBOutlet var bottomLabel: UILabel!

    @IBOutlet var avatar: UIImageView!

    @IBOutlet var widthConstant: NSLayoutConstraint!

    let refreshControl = UIRefreshControl()
        
    var dataList: [[String: String]] = []
    
    @objc func reloadLogin() {
//        dataList = [
//            ["title": "Thông tin cá nhân", "icon": "ico_user"],
//            ["title": "Đổi mật khẩu", "icon": "ico_change_pass"],
//            ["title": "Đơn vị đo", "icon": "ico_measurement", "sw":"1"],
//            ["title": "", "icon": ""],
//            ["title": "Dịch vụ MeWeather", "icon": "ico_meweather"],
//            ["title": "Thỏa thuận dịch vụ", "icon": "ico_info"],
//            ["title": "Phản hồi", "icon": "ico_email"],
//            ["title": "Chia sẻ tới bạn bè", "icon": "ico_share"],
//            ["title": logged() ? "Đăng xuất" : "Đăng nhập", "icon": "ico_logout"],
//        ]
        
          dataList = [
                           ["title": "Thông tin cá nhân", "icon": "ic_user_info"],
                           ["title": "Đổi mật khẩu", "icon": "icon_pass-1"],
                           ["title": "Chia sẻ tới bạn bè", "icon": "ico_share-1"],
                           ["title": "Thông tin dịch vụ", "icon": "ico_ask"],
                           ["title": "Website", "icon": "ico_website"],
                           ["title": "Liên hệ", "icon": "ico_contact"],
                           ["title": "Tổng đài hỗ trợ", "icon": "ico_support"],
                           ["title": "Đăng xuất", "icon": "ico_guide"],
          //                 ["title": logged() ? "Đăng xuất" : "Đăng nhập", "icon": "ico_logout"],
                       ]
        
        phoneNo.text = Information.userInfo != nil ?
            (Information.userInfo?.getValueFromKey("name")) == "" ? (Information.userInfo?.getValueFromKey("phone")) :
            (Information.userInfo?.getValueFromKey("name"))! : "84xxxxxxxxx"
        
        if Information.check == "1" {
            avatar.imageUrl(url: Information.userInfo != nil ? (Information.userInfo?.getValueFromKey("avatar"))! : "")
        } else {
            avatar.image = UIImage.init(named: "ic_default_avatar")
        }
                
        self.tableView.reloadData()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        bottomLabel.text = "Nhà Nông Xanh © 2020 - Phiên bản %@".format(parameters: appVersion as! CVarArg)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
          
       widthConstant.constant = CGFloat(self.screenWidth() * (IS_IPAD ? 0.4 : 0.8));
        
//       dataList = [
//            ["title": "Thông tin cá nhân", "icon": "ico_user"],
//            ["title": "Đổi mật khẩu", "icon": "ico_change_pass"],
//            ["title": "Đơn vị đo", "icon": "ico_measurement", "sw":"1"],
//            ["title": "", "icon": ""],
//            ["title": "Dịch vụ MeWeather", "icon": "ico_meweather"],
//            ["title": "Thỏa thuận dịch vụ", "icon": "ico_info"],
//            ["title": "Phản hồi", "icon": "ico_email"],
//            ["title": "Chia sẻ tới bạn bè", "icon": "ico_share"],
//            ["title": logged() ? "Đăng xuất" : "Đăng nhập", "icon": "ico_logout"],
//        ]
        
        dataList = [
                   ["title": "Thông tin cá nhân", "icon": "ic_user_info"],
                  ["title": "Đổi mật khẩu", "icon": "icon_pass-1"],
                  ["title": "Chia sẻ tới bạn bè", "icon": "ico_share-1"],
                  ["title": "Thông tin dịch vụ", "icon": "ico_ask"],
                  ["title": "Website", "icon": "ico_website"],
                  ["title": "Liên hệ", "icon": "ico_contact"],
                  ["title": "Tổng đài hỗ trợ", "icon": "ico_support"],
                  ["title": "Đăng xuất", "icon": "ico_guide"],
//                 ["title": logged() ? "Đăng xuất" : "Đăng nhập", "icon": "ico_logout"],
             ]
        
//        tableView.refreshControl = refreshControl
//           
//        refreshControl.tintColor = UIColor.black
//        
//        refreshControl.addTarget(self, action: #selector(didRequestNotification), for: .valueChanged)
                   
//        dataList = NSMutableArray.init()
                
        tableView.withCell("PC_Weather_Menu_Cell")
        
//        tableView.withHeaderOrFooter("PC_Header_Tab")
        
//        didRequestNotification()
        
        if Information.check == "1" {
//            avatar.action(forTouch: [:]) { (objc) in
//                    self.center()?.pushViewController(PC_Inner_Info_ViewController.init(), animated: true)
//                    self.root()?.showCenterPanel(animated: true)
//            }
        } else {
            avatar.image = UIImage.init(named: "ic_default_avatar")
        }
        
//        userName.alpha = Information.check == "1" ? 1 : 0
        
//        phoneNo.alpha = Information.check == "1" ? 1 : 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.tableView.reloadData()
        
//        userName.text = Information.userInfo?.getValueFromKey("name") == "" ? "Vô danh" : Information.userInfo?.getValueFromKey("name")
    }
    
    @objc func didRequestNotification() {
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"getBookCategory",
                                                    "session":Information.token ?? "",
                                                    "overrideAlert":"1",
                                                    ], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                                                         
            self.refreshControl.endRefreshing()
                        
            if (error != nil) || result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                return
            }
                        
//            self.dataList.removeAllObjects()
//
//            let noti = (result["result"] as! NSArray).withMutable()
//
//            for not in noti! {
//                (not as! NSMutableDictionary)["open"] = "0"
//                if ((not as! NSMutableDictionary)["sub_category"] as! NSArray).count != 0 {
//                    ((not as! NSMutableDictionary)["sub_category"] as! NSMutableArray).insert(["name": "Tất cả", "id": (not as! NSMutableDictionary)["id"], "title": (not as! NSMutableDictionary)["name"]], at: 0)
//                }
//            }
            
//            self.dataList.addObjects(from: noti!)
//
//            self.dataList.add(NSMutableDictionary.init(dictionary:["avatar": "id", "name": "Tác giả", "sub_category": [], "open": "0", "id": "9999"]))
//
//            self.dataList.add(NSMutableDictionary.init(dictionary:["avatar": "id", "name": "Tuyển tập chọn lọc", "sub_category": [], "open": "0", "id": "99100"]))
//
//            self.dataList.add(NSMutableDictionary.init(dictionary:["avatar": "id", "name": "Nhà xuất bản", "sub_category": [], "open": "0", "id": "99101"]))

            self.tableView.reloadData()
        })
    }
    
    @IBAction func didPressBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressFAQ() {

    }
    
    @objc func didRequestLogout() {
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"logout",
                                                    "session":Information.token ?? "",
                                                    "deviceId":self.deviceUUID() ?? "",
                                                    "push_token": FirePush.shareInstance()?.deviceToken() ?? self.uniqueDeviceId() as Any,
                                                    "overrideAlert":"1",
                                                    ], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
//            let result = response?.dictionize() ?? [:]
//                                                                                 
//            if (error != nil) || result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
//                self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
//                return
//            }
            
            Information.removeInfo()

            let login = self.loginNav(type: "logOut") { (info) in
                self.checkLogin()
            }
            self.center()?.present(login, animated: true, completion: nil)
        })
    }
    
    func check() -> Bool {
      return Information.check == "0"
    }
}

extension TG_Intro_ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if check() && indexPath.row == 3 { return 10 }
        return 55 //check() ? [0, 1, 4, 5, 8].contains(indexPath.row) ? 0 : UITableView.automaticDimension : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PC_Weather_Menu_Cell", for: indexPath)
                 
        (self.withView(cell, tag: 11) as! UIImageView).image = UIImage.init(named: data["icon"] ?? "trans")

        (self.withView(cell, tag: 12) as! UILabel).text = data["title"]
        
        (self.withView(cell, tag: 19) as! UIView).alpha = indexPath.row == 3 ? 1 : 0;
        
        (self.withView(cell, tag: 13) as! UILabel).alpha = data["sw"] != nil ? 1 : 0;

        (self.withView(cell, tag: 15) as! UILabel).alpha = data["sw"] != nil ? 1 : 0;

        
        let sw = (self.withView(cell, tag: 14) as! UISwitch)

        sw.isUserInteractionEnabled = false
        
        sw.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        sw.isOn = self.getValue("deg") == "0"

//        sw.action(forTouch: [:]) { (obj) in
//            self.addValue(self.getValue("deg") == "1" ? "0" : "1", andKey: "deg")
//            sw.isOn = self.getValue("deg") == "0"
//        }
        
        sw.alpha = data["sw"] != nil ? 1 : 0;
        
        
        return cell
    }
    
    func checkLogin() {
        if (self.topviewcontroler()?.isKind(of: PC_Weather_Main_ViewController.self))! {
            (self.topviewcontroler() as! PC_Weather_Main_ViewController).didGetWeather()
            (self.topviewcontroler() as! PC_Weather_Main_ViewController).reloadState()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        self.root()?.showCenterPanel(animated: true)
        
        switch indexPath.row {
            case 0:
                if logged() {
                    self.center()?.pushViewController(Weather_Info_ViewController.init(), animated: true)
                } else {
                    let login = self.loginNav(type: "logOut") { (info) in
                        self.checkLogin()
                    }
                    self.center()?.present(login, animated: true, completion: nil)
                }
                break
                
             case 1:
                if logged() {
                   self.center()?.pushViewController(PC_ChangePass_ViewController.init(), animated: true)
                } else {
                    let login = self.loginNav(type: "logOut") { (info) in
                        self.checkLogin()
                    }
                    self.center()?.present(login, animated: true, completion: nil)
                }
                break
                
            case 2:
//                let cell = tableView.cellForRow(at: indexPath)
//
//                let sw = (self.withView(cell, tag: 14) as! UISwitch)
//
//                self.addValue(self.getValue("deg") == "1" ? "0" : "1", andKey: "deg")
//
//                sw.isOn = self.getValue("deg") == "0"
//
//                (self.topviewcontroler() as! PC_Weather_Main_ViewController).didGetWeather()
                
                self.shareAll()

                break
                
            case 3:
                let webView = PC_Web_ViewController.init()
                              
                webView.titleString = "Thông tin dịch vụ"
              
                self.center()?.pushViewController(webView, animated: true)
                break
                
            case 4:
                
                guard let url = URL(string: "http://m.nhanongxanh.vn/") else { return }
                UIApplication.shared.open(url)
              
                break
                
            case 5:
                let webView = PC_Web_ViewController.init()
                
                webView.titleString = "Liên hệ"
                
                self.center()?.pushViewController(webView, animated: true)
                break
                
        case 6:
            let url: NSURL = URL(string: "TEL://19001595")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            break
//            case 6:
//                if logged() {
//                   self.center()?.pushViewController(Weather_FeedBack_ViewController.init(), animated: true)
//                } else {
//                    let login = self.loginNav(type: "logOut") { (info) in
//                        self.checkLogin()
//                    }
//                    self.center()?.present(login, animated: true, completion: nil)
//                }
//                break
                
//            case 7:
//                self.shareAll()
//                break
            
            case 7:
                if logged() {
                   DropAlert.shareInstance()?.alert(withInfor: ["cancel":"Thoát", "buttons":["Đăng xuất"], "title":"Thông báo", "message": "Bạn có muốn đăng xuất khỏi tài khoản ?"], andCompletion: { (index, objc) in
                       if index == 0 {
                        self.didRequestLogout()
                        if (self.topviewcontroler()?.isKind(of: NN_Root_ViewController.self))! {
                            (self.topviewcontroler() as! NN_Root_ViewController).didResetLogout()
                        }
                       }
                   })
                } else {
                    let login = self.loginNav(type: "logOut") { (info) in
                        self.checkLogin()
                    }
                    self.center()?.present(login, animated: true, completion: nil)
                }
                break
            
            default:
                break
            }
    }
    
    func shareAll() {
      let text = "Chia sẻ bạn bè"
      let myWebsite = NSURL(string:"http://m.nhanongxanh.vn/")
      let shareAll = [text, myWebsite as Any]
      let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.topviewcontroler().view
//      activityViewController.popoverPresentationController?.sourceRect = self.topviewcontroler().view.frame

      self.present(activityViewController, animated: true, completion: nil)
    }
}

extension String {
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}
