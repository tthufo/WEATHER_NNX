//
//  PC_Forgot_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 8/4/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

class PC_Forgot_ViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var logo: UIImageView!
    
    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var login: UIView!
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var cover: UIView!
    
    @IBOutlet var uNameBg: UIView!
    
    @IBOutlet var uName: UITextField!
    
    @IBOutlet var submit: UIButton!
    
    @IBOutlet var uNameErr: UILabel!
    
    @IBOutlet var count: UILabel!
        
    var typing: NSString!
    
    var kb: KeyBoard!
    
    let bottomGap = IS_IPHONE_5 ? 40.0 : 80.0

    let topGap = IS_IPHONE_5 ? 110 : 150
    
    var isValid: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kb = KeyBoard.shareInstance()
        
        self.setUp()
                
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
        
        uName.addTarget(self, action: #selector(textIsChanging), for: .editingChanged)
                
        if Information.check == "1" {
            self.logo.image = UIImage(named: "ico_lock")
        }
        
        submit.setTitle(typing == "register" ? "Đăng ký" : "Lấy mật khẩu", for: .normal)
        
        bgView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kb.keyboardOff()
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
    
    func setUp() {
        let bbgg = Information.bbgg != nil && Information.bbgg != ""

        var frame = logo.frame
        
        frame.origin.y = CGFloat(self.screenHeight() - 140) / 2
        
        frame.origin.x = CGFloat(self.screenWidth() - 200) / 2
              
        frame.size.width = CGFloat(200)
        
        frame.size.height = CGFloat(200)

        logo.frame = frame
        
        logo.alpha = 1
        
        UIView.animate(withDuration: 1.5, animations: {
            self.cover.alpha = bbgg ? 0.3 : 0
        }) { (done) in
            UIView.transition(with: self.bg, duration: 1.5, options: .transitionCrossDissolve, animations: {
                self.bg.image = bbgg ? Information.bbgg!.stringImage() : UIImage(named: "ic_bgr_01")
            }, completion: { (done) in
                UIView.animate(withDuration: 1.5, animations: {
                    self.cover.alpha = 0
                }) { (done) in
                   
                }
            })
        }
        
        UIView.animate(withDuration: 0, animations: {
            var frame = self.logo.frame
            
            frame.origin.y -= CGFloat((self.screenHeight()/2 - (237 * 0.7)) / 2) + (CGFloat(self.topGap) - 100) + (IS_IPHONE_5 ? 140 : 60)
            
            self.logo.frame = frame
            
            self.logo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (done) in
            self.setUpLogin()
        }
    }
    
    func setUpLogin() {
        var frame = login.frame
        
//        frame.origin.y = CGFloat(self.screenHeight() - 380) / 2 + CGFloat(self.topGap)
//
//        frame.size.width = CGFloat(self.screenWidth() - (IS_IPAD ? 200 : 40))
        
        frame.origin.y = CGFloat(self.screenHeight() - 450) / 2 + CGFloat(self.topGap)
              
        frame.size.width = CGFloat(self.screenWidth() - (IS_IPAD ? 200 : 40))
               
        frame.size.height = CGFloat(CGFloat(self.screenHeight()) - CGFloat(self.topGap) - CGFloat(self.bottomGap) - (IS_IPAD ? 240 : 170))

        frame.origin.x = IS_IPAD ? 100 : 20
        
        login.frame = frame
        
        self.view.addSubview(login)
        
        UIView.animate(withDuration: 1, animations: {
            
            self.login.alpha = 1
            
        }) { (done) in
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == uName {
            self.view.endEditing(true)
        }
        
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        count.text = "%i/10".format(parameters: updatedString!.count > 10 ? 10 : updatedString!.count)
//        return updatedString!.count >= 11 ? false : true
//    }
    
    @IBAction func didPressBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func didPressSubmit() {
        self.view.endEditing(true)
                
        isValid = self.checkPhone()
        if !isValid {
            validPhone()
            return
        }
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"forgetPassword",
                                                    "msisdn":convertPhone(),
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
            
            let confirm = PC_Confirm_ViewController.init()
            
            confirm.uName = self.convertPhone()
            
            self.navigationController?.pushViewController(confirm, animated: true)
            
//            self.showToast("Lấy lại mật khẩu thành công. Mật khẩu mới sẽ đưởi gửi về số điện thoại %@".format(parameters: self.uName.text!), andPos: 0)
//            self.didPressBack()
        })
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
    
    func validPhone() {
      uNameErr.alpha = isValid ? 0 : 1
      uNameBg.backgroundColor = isValid ? UIColor.white : UIColor.red
    }
    
    @objc func textIsChanging(_ textField:UITextField) {
        isValid = true
        validPhone()
//        let isEmail: Bool = uName.text?.count != 0 && (uName.text?.isValidEmail())!
//        uNameBg.backgroundColor = isEmail ? AVHexColor.color(withHexString: "#F2F2F2") : .red
//        uNameErr.alpha = isEmail ? 0 : 1
//        submit.isEnabled = isEmail
//        submit.alpha = isEmail ? 1 : 0.5
    }
    
    func toolBar() -> UIToolbar {
        
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.screenWidth()), height: 50))
        
        toolBar.barStyle = .default
        
        toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem.init(title: "Thoát", style: .done, target: self, action: #selector(disMiss))]
        return toolBar
    }
    
    @objc func disMiss() {
        self.view.endEditing(true)
    }
}
