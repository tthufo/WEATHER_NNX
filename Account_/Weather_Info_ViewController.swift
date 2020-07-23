//
//  Weather_Info_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MessageUI

class Weather_Info_ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var avatar: UIImageView!
    
    @IBOutlet var avatarName: UILabel!

    @IBOutlet var phone: UILabel!

    @IBOutlet var name: UILabel!
    
    @IBOutlet var nameSub: UILabel!

    @IBOutlet var package: UILabel!
    
    @IBOutlet var packageSub: UILabel!
    
    @IBOutlet var expire: UILabel!

    var avatarTemp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInfo()
        
        name.action(forTouch: [:]) { (obj) in
            let edit = Weather_Name_ViewController.init()
            edit.uName = Information.userInfo?.getValueFromKey("name") // == ""
//                ? Information.userInfo?.getValueFromKey("msisdn") : Information.userInfo?.getValueFromKey("name")
            self.navigationController?.pushViewController(edit, animated: true)
        }
        
       nameSub.action(forTouch: [:]) { (obj) in
            let edit = Weather_Name_ViewController.init()
            edit.uName = Information.userInfo?.getValueFromKey("name") // == ""
//                ? Information.userInfo?.getValueFromKey("msisdn") : Information.userInfo?.getValueFromKey("name")
            self.navigationController?.pushViewController(edit, animated: true)
        }
        
        package.action(forTouch: [:]) { (obj) in
            self.didGetPackage(showMenu: true)
        }
        
        packageSub.action(forTouch: [:]) { (obj) in
           self.didGetPackage(showMenu: true)
        }

        avatar.imageUrl(url: (Information.userInfo?.getValueFromKey("avatar"))!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        didGetInfo()
        
        didGetPackage(showMenu: false)
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didGetInfo() {
        LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getUserInfo",
                                                    "session": Information.token ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                                                
            if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                return
            }
                   
            self.add((response?.dictionize()["result"] as! NSDictionary).reFormat() as? [AnyHashable : Any], andKey: "info")

            Information.saveInfo()
            
            self.viewInfo()
        })
    }
    
    func viewInfo() {
        avatarName.text = Information.userInfo?.getValueFromKey("name") == "" ? Information.userInfo?.getValueFromKey("msisdn") : Information.userInfo?.getValueFromKey("name")

        phone.text = Information.userInfo?.getValueFromKey("msisdn")
        
        name.text = Information.userInfo?.getValueFromKey("name")
        
//        avatar.imageUrl(url: (Information.userInfo?.getValueFromKey("avatar"))!)
    }
    
    func didEditAvatar() {
         LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"updateUserInfo",
                                                      "session":Information.token ?? "",
                                                      "avatar":(self.avatarTemp.imageScaledToHalf() as UIImage).fullImageString(),
                                                      "overrideAlert":"1",
                                                      "overrideLoading":"1",
                                                      "host":self], withCache: { (cacheString) in
         }, andCompletion: { (response, errorCode, error, isValid, object) in
             let result = response?.dictionize() ?? [:]
                                                 
             if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                 self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                 return
             }
          
             self.didGetInfo()
            
             self.showToast("Cập nhật thông tin thành công", andPos: 0)
        })
     }
    
    func didGetPackage(showMenu: Bool) {
        LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getPackageInfo",
                                                    "session": Information.token ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                          
            if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                return
            }
                    
            let info = ((result["result"] as! NSArray)[0] as! NSDictionary)
            
            self.package.text = info.getValueFromKey("status") == "1" ? info.getValueFromKey("name") : "Chưa đăng ký"
            
            self.expire.text = info.getValueFromKey("status") == "1" ? info.getValueFromKey("expireTime") : ""
            
            if showMenu {
                EM_MenuView.init(package: (info as! [AnyHashable : Any])).show { (index, objc, menu) in
                    if index == 0 {
//                        let data = (objc as! NSDictionary)
//                        if (MFMessageComposeViewController.canSendText()) {
//                             let controller = MFMessageComposeViewController()
//                             controller.body = data.getValueFromKey("reg_keyword")
//                             controller.recipients = [data.getValueFromKey("reg_shortcode")]
//                             controller.messageComposeDelegate = self
//                             self.present(controller, animated: true, completion: nil)
//                         }
                    }
                }
            }
        })
    }
    
    @IBAction func didPressImage() {
           EM_MenuView.init(settingMenu: [:]).show(completion: { (indexing, obj, menu) in
               switch indexing {
               case 1:
//                   self.didPressPreview(image: self.avatarTemp != nil ? self.avatarTemp as Any: Information.userInfo?.getValueFromKey("Avatar") as Any)
                   break
               case 2:
                   Permission.shareInstance()?.askCamera { (camType) in
                       switch (camType) {
                       case .authorized:
                           DispatchQueue.main.async(execute: {
                               Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                                   if image != nil {
                                       self.avatarTemp = (image as! UIImage)
                                       self.avatar.image = (image as! UIImage)
                                       Information.avatar = (image as! UIImage)
                                    self.didEditAvatar()
                                   }
                               })
                           })
                           break
                       case .denied:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       case .per_denied:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       case .per_granted:
                           DispatchQueue.main.async(execute: {
                               Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                                   if image != nil {
                                       self.avatarTemp = (image as! UIImage)
                                       self.avatar.image = (image as! UIImage)
                                       Information.avatar = (image as! UIImage)
                                    self.didEditAvatar()
                                   }
                               })
                           })
                           break
                       case .restricted:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       default:
                           break
                       }
                   }
                   break
               case 3:
                   Permission.shareInstance()?.askGallery { (camType) in
                      switch (camType) {
                      case .authorized:
                           DispatchQueue.main.async(execute: {
                              Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                                  if image != nil {
                                   self.avatarTemp = (image as! UIImage)
                                   self.avatar.image = (image as! UIImage)
                                   Information.avatar = (image as! UIImage)
                                    self.didEditAvatar()
                                  }
                              })
                          })
                          break
                      case .denied:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      case .per_denied:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      case .per_granted:
                           DispatchQueue.main.async(execute: {
                              Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                                  if image != nil {
                                   self.avatarTemp = (image as! UIImage)
                                   self.avatar.image = (image as! UIImage)
                                   Information.avatar = (image as! UIImage)
                                    self.didEditAvatar()
                                  }
                              })
                           })
                          break
                      case .restricted:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      default:
                          break
                      }
                  }
                   break
               default:
                   break
               }
           })
       }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
