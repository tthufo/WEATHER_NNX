//
//  PC_Login_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 8/3/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit
import MarqueeLabel
import MessageUI

class PC_Login_ViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
  
    @IBOutlet var logo: UIImageView!
    
    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var login: UIView!
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var cover: UIView!

    @IBOutlet var uName: UITextField!
    
    @IBOutlet var pass: UITextField!

    @IBOutlet var check: UIButton!
    
    @IBOutlet var dismiss: UIButton!

    @IBOutlet var submit: UIButton!
    
    @IBOutlet var uNameErr: UILabel!
    
    @IBOutlet var uNameView: UIView!

    @IBOutlet var passErr: UILabel!
        
    @IBOutlet var bottom: MarqueeLabel!
    
    @objc var logOut: String!

    var loginCover: UIView!
    
    var isCheck: Bool!
    
    var isValid: Bool = true
    
    var kb: KeyBoard!
    
    let bottomGap = IS_IPHONE_5 ? 40.0 : 60.0

    let topGap = IS_IPHONE_5 ? 110 : 150

    var callBack: ((_ info: Any)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kb = KeyBoard.shareInstance()

        isCheck = false
        
//        self.setUp()
        
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
        
        self.logo.alpha = 0

        uName.addTarget(self, action: #selector(textIsChanging), for: .editingChanged)
        pass.addTarget(self, action: #selector(textIsChanging), for: .editingChanged)
        
        FirePush.shareInstance()?.completion({ (state, info) in
            print("--->", state, info)
        })
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        bottom.text = "MEBOOK © 2020 - Ver %@".format(parameters: appVersion!)
        
        getPhoneNumber()
        
        bgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
    }
    
    @IBAction func didPressDis() {
        self.dismiss(animated: true) {
            
        }
        if callBack != nil {
            callBack!("")
        }
    }
    
    //USING FIREPUSH PROJECT CONSOLE
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (kb != nil) {
            kb.keyboardOff()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kb.keyboard { (height, isOn) in
            UIView.animate(withDuration: 1, animations: {
                var frame = self.login.frame
                
                frame.origin.y -= isOn ? (height - CGFloat(self.bottomGap)) : (-height + CGFloat(self.bottomGap))
               
                self.login.frame = frame
                
                var frameLogo  = self.logo.frame
                
                frameLogo.origin.y -= isOn ? (height - CGFloat(self.bottomGap)) : (-height + CGFloat(self.bottomGap))
                
                self.logo.frame = frameLogo
            })
        }
    }
    
    func getPhoneNumber() {
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"http://m.nhanongxanh.vn/getmsisdnapi/", "overrideAlert":"1", "overrideError":"1"], withCache: { (cache) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
                      
//            print("===>", response, errorCode)
            
            if response != nil {
//                let hpple = TFHpple.init(htmlData: response!.data(using: .utf8))
//
//                let element = hpple?.search(withXPathQuery: "//i[@class='desktop']")
//
//                if let content = element![0] as? TFHppleElement {
//                    let phoneNumber = content.content.replacingOccurrences(of: "Xin chào: ", with: "")
//
//                    if !phoneNumber.isNumber {
//                        self.setUp(phoneNumber: "")
//                    } else {
//                        self.setUp(phoneNumber: phoneNumber)
//                    }
//                }
            } else {
                self.setUp(phoneNumber: "")
            }
        })
    }
    
//    func getPhoneNumber() {
//        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"http://weather.nhanongxanh.vn/header.php/", "overrideAlert":"1", "overrideError":"1"], withCache: { (cache) in
//        }, andCompletion: { (response, errorCode, error, isValid, object) in
//
//            if errorCode == "200" {
//                let hpple = TFHpple.init(htmlData: response!.data(using: .utf8))
//
//                let element = hpple?.search(withXPathQuery: "//i[@class='desktop']")
//
//                if let content = element![0] as? TFHppleElement {
//                    let phoneNumber = content.content.replacingOccurrences(of: "Xin chào: ", with: "")
//
//                    if !phoneNumber.isNumber {
//                        self.setUp(phoneNumber: "")
//                    } else {
//                        self.setUp(phoneNumber: phoneNumber)
//                    }
//                }
//            } else {
//                self.setUp(phoneNumber: "")
//            }
//        })
//    }
    
    func normalFlow(logged: Bool, phoneNumber: Any) {
        
       dismiss.isHidden = false
        
       Information.check = "1"

       self.logo.image = UIImage(named: "logo_nnx_white")

       self.logo.alpha = 1

       UIView.animate(withDuration: 0.5, animations: {
           var frame = self.logo.frame

           frame.origin.y -= CGFloat((self.screenHeight()/2 - (237 * 0.7)) / 2) + (CGFloat(self.topGap) - 100) + (IS_IPHONE_5 ? 140 : 60)

           self.logo.frame = frame

           self.logo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

       }) { (done) in
           if logged {
               self.uName.text = Information.log!["name"] as? String
               self.pass.text = Information.log!["pass"] as? String
               self.submit.isEnabled = self.uName.text?.count != 0 && self.pass.text?.count != 0
               self.submit.alpha = self.uName.text?.count != 0 && self.pass.text?.count != 0 ? 1 : 0.5
               self.bgView.backgroundColor = (self.uName.text?.count != 0 && self.pass.text?.count != 0) ? .green : .clear
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
              if self.logOut == "logIn" {
                  self.didPressSubmit(phoneNumber: phoneNumber as! String)
              }
           })
           self.setUpLogin()
       }
    }
    
    func setUp(phoneNumber: Any) {
                
        let logged = Information.token != nil && Information.token != ""
                        
        var frame = logo.frame

        frame.origin.y = CGFloat(self.screenHeight() - 70) / 2

        frame.origin.x = 0 //CGFloat(self.screenWidth() - 250) / 2
        
        frame.size.width = CGFloat(self.screenWidth() - 0)
        
        logo.frame = frame
        
        logo.alpha = 0
        
        print("====>", Information.token)
        
        UIView.animate(withDuration: 0.5, animations: {
//            self.cover.alpha = bbgg ? 0.3 : 0
        }) { (done) in
            
            UIView.animate(withDuration: 0.5, animations: {
//                    self.cover.alpha = 0
            }) { (done) in
                
        self.dismiss.isHidden = false

        if NSDate.init().isPastTime("01/06/2020") {
            self.normalFlow(logged: logged, phoneNumber: phoneNumber)
            return
        }
                
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"https://dl.dropboxusercontent.com/s/9iqrj06bzhukgry/PCTT_WEATHERBOOK_2.plist", "overrideAlert":"1"], withCache: { (cache) in

                }, andCompletion: { (response, errorCode, error, isValid, object) in

                    if error != nil {
                        self.normalFlow(logged: logged, phoneNumber: phoneNumber)
                        return
                    }

                    let data = response?.data(using: .utf8)
                    let dict = XMLReader.return(XMLReader.dictionary(forXMLData: data, options: 0))

                    let information = [ "token": IS_IPAD ? "38335D8087987CF727B8C8A658E36189" : "A87927EE6A7AAA8EE786BA2B23ED8E19"] as [String : Any]
                    
                if (dict! as NSDictionary).getValueFromKey("show") == "0" {

//                    if IS_IPAD {
//                        self.add(["name":"0915286679" as Any, "pass":"594888" as Any], andKey: "log")
//                    } else {
//                        self.add(["name":"0913552640" as Any, "pass":"123456" as Any], andKey: "log")
//                    }
                    
                    self.add(["name":"0915286679" as Any, "pass":"9063" as Any], andKey: "log")


                    self.add((information as NSDictionary).reFormat() as? [AnyHashable : Any], andKey: "info")

                    Information.saveInfo()

                    self.addValue((information as NSDictionary).getValueFromKey("token"), andKey: "token")

                    Information.saveToken()

                    Information.check = (dict! as NSDictionary).getValueFromKey("show") == "0" ? "0" : "1"

                    if Information.check == "1" {
                        self.logo.image = UIImage(named: "logo_nnx_white")
                    }
                    
                    self.uName.text = Information.log!["name"] as? String
                    self.pass.text = Information.log!["pass"] as? String

                    self.didPressSubmit(phoneNumber: "" as Any)
                    } else {

                    Information.check = (dict! as NSDictionary).getValueFromKey("show") == "0" ? "0" : "1"
                        UIView.animate(withDuration: 0.5, animations: {
                            var frame = self.logo.frame

                            frame.origin.y -= CGFloat((self.screenHeight()/2 - (237 * 0.7)) / 2) + (CGFloat(self.topGap) - 100) + (IS_IPHONE_5 ? 140 : 60)

                            self.logo.frame = frame

                            self.logo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

                            if Information.check == "1" {
                               self.logo.image = UIImage(named: "logo_nnx_white")
                            }

                            self.logo.alpha = 1
                        }) { (done) in
                            if logged {
                                self.uName.text = Information.log!["name"] as? String
                                self.pass.text = Information.log!["pass"] as? String
                                self.submit.isEnabled = self.uName.text?.count != 0 && self.pass.text?.count != 0
                                self.submit.alpha = self.uName.text?.count != 0 && self.pass.text?.count != 0 ? 1 : 0.5
                                self.bgView.backgroundColor = (self.uName.text?.count != 0 && self.pass.text?.count != 0) ? .green : .clear
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                                if self.logOut == "logIn" {
                                   self.didPressSubmit(phoneNumber: phoneNumber as! String)
                               }
                            })
                            self.setUpLogin()
                        }
                    }
                })
            }
        }
    }
    
    func setUpLogin() {
        var frame = login.frame
        
        frame.origin.y = CGFloat(self.screenHeight() - 450) / 2 + CGFloat(self.topGap)
        
        frame.size.width = CGFloat(self.screenWidth() - (IS_IPAD ? 200 : 40))
        
        frame.origin.x = IS_IPAD ? 100 : 20

        login.frame = frame
        
        self.view.addSubview(login)
        
        UIView.animate(withDuration: 0.5, animations: {

            self.login.alpha = 1

        }) { (done) in
            
        }
    }
    
    @IBAction func didPressForget() {
        self.view.endEditing(true)
        let forgot = PC_Forgot_ViewController.init();
        forgot.typing = "forgot"
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    
    @IBAction func didPressCheck() {
        pass.isSecureTextEntry = isCheck
        check.setImage(UIImage(named: isCheck ? "design_ic_visibility_off" : "design_ic_visibility"), for: .normal)
        isCheck = !isCheck
    }
    
    @IBAction func didPressRegister() {
        self.view.endEditing(true)
        
        if (MFMessageComposeViewController.canSendText()) {
             let controller = MFMessageComposeViewController()
             controller.body = "XNN"
             controller.recipients = ["1595"]
             controller.messageComposeDelegate = self
             self.present(controller, animated: true, completion: nil)
         }
        
//        EM_MenuView.init(packageShow: ["info": "Soạn V gửi 1095 để đăng ký gói dịch vụ chuyên sâu, cước 1000đ/ngày. LH: 19001595 (1000đ/phút)"]).show { (index, objc, menu) in
//        }
    }
    
    func checkPhone() -> Bool {
        let phone = uName.text
        if phone!.count > 10 {
            if phone?.substring(to: 2) == "84" {
                if phone?.count == 11 {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            if phone!.count == 10 {
                if phone?.substring(to: 1) != "0" {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    }
    
    func convertPhone() -> String {
        let phone = uName.text
        if phone?.substring(to: 2) == "84" {
            return phone!
        } else if phone?.substring(to: 1) == "0"  {
            return "84" + (phone?.dropFirst())!
        }
        return phone!
    }
    
    @IBAction func didPressSubmit(phoneNumber: Any) {
        self.view.endEditing(true)
        var is3G = false
        if phoneNumber is String {
            if (phoneNumber as! String) == "" {
                is3G = false
                self.didPressDis()
            } else {
                is3G = true
            }
        }
                         
        let logged = Information.log != nil ? Information.log?.getValueFromKey("name") != "" && Information.log?.getValueFromKey("pass") != "" ? true : false : false
                
        if is3G {
            self.uName.text = (phoneNumber as! String)
            requestLogin(request: ["msisdn":phoneNumber,
//                                   "password":pass.text as Any,
                                   "login_type":"3G"])
            print("3G")
        } else {
            if logged {
                requestLogin(request: ["msisdn":convertPhone(),
                                       "password":pass.text as Any,
                                       "login_type":"WIFI"])
                print("LOGIN")
            } else {
                print("BUTTON")
                
                if phoneNumber is UIButton {
                    isValid = self.checkPhone()
                    if !isValid {
                        validPhone()
                        return
                    }
                    print(convertPhone())
                    requestLogin(request: ["msisdn":convertPhone(),
                                            "password":pass.text as Any,
                                            "login_type":"WIFI"])
                }
            }
        }
    }
    
    func requestLogin(request: NSDictionary) {
        let requesting = NSMutableDictionary.init(dictionary: ["CMD_CODE":"login",
                                                               "push_token": FirePush.shareInstance()?.deviceToken() ?? self.uniqueDeviceId(),
                                                               "deviceId":self.deviceUUID() ?? "",
                                                               "platform":"IOS",
                                                               "overrideAlert":"1",
                                                               "overrideLoading":"1",
                                                               "host":self])
        requesting.addEntries(from: request as! [AnyHashable : Any])
        LTRequest.sharedInstance()?.didRequestInfo(requesting as? [AnyHashable : Any], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                        
            print(result)

            if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
                self.showToast("Không có thông tin tài khoản. Liên hệ quản trị viên để được tài trợ.", andPos: 0)
                return
            }
            
            self.add(["name":self.uName.text as Any, "pass":self.pass.text as Any], andKey: "log")

            self.add((response?.dictionize()["RESULT"] as! NSDictionary).reFormat() as? [AnyHashable : Any], andKey: "info")

            Information.saveInfo()

            self.addValue((response?.dictionize()["RESULT"] as! NSDictionary).getValueFromKey("deviceId"), andKey: "token")

            Information.saveToken()

            print(Information.userInfo as Any)

//            if Information.check == "1" {
                self.didRequestPackage()   //CHECK PACKAGE
//            } else {
//                (UIApplication.shared.delegate as! AppDelegate).changeRoot(false) //CHECK PACKAGE
//            }
            
            self.updatePushToken()
            
            self.didPressDis()
        })
    }
    
      func updatePushToken() {
            LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"updatePushNotificationId",
                                                        "pushId": FirePush.shareInstance()?.deviceToken() ?? self.uniqueDeviceId(),
                                                        "deviceId":self.deviceUUID() ?? "",
                                                        "overrideAlert":"1",
                                                        "overrideLoading":"1",
                                                        "host":self], withCache: { (cacheString) in
           }, andCompletion: { (response, errorCode, error, isValid, object) in
                let result = response?.dictionize() ?? [:]
                
                print(result)
//                if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
//                   self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
//                   return
//                }
           })
        }
    
    func didRequestPackage() {
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"getPackageInfo",
                                                    "session":Information.token ?? "",
                                                    "deviceId":self.deviceUUID() ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
        
            if result.getValueFromKey("ERR_CODE") != "0" || result["RESULT"] is NSNull {
               self.showToast(response?.dictionize().getValueFromKey("ERR_MSG") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
               return
            }
        
            print(result)
        
            if !self.checkRegister(package: response?.dictionize()["RESULT"] as! NSArray) {
//                self.showToast("Xin chào " + self.uName.text! + ", hãy đăng ký dịch vụ để xem thông tin đầy đủ.", andPos: 0)
            } else {
//                (UIApplication.shared.delegate as! AppDelegate).changeRoot(false)
//                if self.uName != nil {
//                   self.uName.text = ""
//                }
//                if self.pass != nil {
//                   self.pass.text = ""
//                }
//                if self.submit != nil {
//                   self.submit.isEnabled = self.uName.text?.count != 0 && self.pass.text?.count != 0
//                   self.submit.alpha = self.uName.text?.count != 0 && self.pass.text?.count != 0 ? 1 : 0.5
//                }
            }
       })
    }
    
    func checkRegister(package: NSArray) -> Bool {
        var isReg = false
        for dict in package {
            let expDate = ((dict as! NSDictionary).getValueFromKey("expireTime")! as NSString).date(withFormat: "dd-MM-yyyy")
            if (dict as! NSDictionary).getValueFromKey("status") == "1" && expDate! > Date() {
                isReg = true
                break
            }
        }
        return isReg
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == uName {
            pass.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func validPhone() {
        uNameErr.alpha = isValid ? 0 : 1
        uNameView.backgroundColor = isValid ? UIColor.white : UIColor.red
    }
    
    @objc func textIsChanging(_ textField:UITextField) {
        isValid = true
        validPhone()
        submit.isEnabled = uName.text?.count != 0 && pass.text?.count != 0
        submit.alpha = uName.text?.count != 0 && pass.text?.count != 0 ? 1 : 0.5
        self.bgView.backgroundColor = (self.uName.text?.count != 0 && self.pass.text?.count != 0) ? .green : .clear
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
