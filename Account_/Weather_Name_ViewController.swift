//
//  Weather_Name_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

//import MarqueeLabel

class Weather_Name_ViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet var bg: UIImageView!

    var kb: KeyBoard!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var cell1: UITableViewCell!
    
    @IBOutlet var oldPass: UITextField!

    @IBOutlet var submit: UIButton!
    
    var uName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_IPAD {

        }
        
        kb = KeyBoard.shareInstance()
        
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
        
        oldPass.text = uName ?? ""
        
        submit.isEnabled = oldPass.text?.count != 0
        submit.alpha = oldPass.text?.count != 0 ? 1 : 0.5
                
        oldPass.addTarget(self, action: #selector(textOldIsChanging), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kb.keyboardOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isEmbed() {
//           bottomHeight.constant = 100
        }
        
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        kb.keyboard { (height, isOn) in
            self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: isOn ? (height - 100) : 0, right: 0)
        }
    }
    
    @IBAction func didPressBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressCheck(sender: UIButton) {
        let tag = sender.tag

        let fields = [oldPass]

        let check = sender.currentImage == UIImage(named: "design_ic_visibility_off")
        (fields[tag - 1])!.isSecureTextEntry = check
        sender.setImage(UIImage(named: !check ? "design_ic_visibility_off" : "design_ic_visibility"), for: .normal)
    }
    
    @IBAction func didPressSubmit() {
        self.view.endEditing(true)
        
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"changePassword",
                                                    "old_password":oldPass.text as Any,
//                                                    "new_password":newPass.text as Any,
                                                    "session":Information.token ?? "",
                                                    "overrideLoading":"1",
                                                    "overrideAlert":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]

            if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                return
            }
                        
            self.showToast("Đổi mật khẩu thành công", andPos: 0)

            let uInfo: NSDictionary = Information.log!

//            self.add(["name":uInfo["name"] as Any, "pass":self.newPass.text as Any], andKey: "log")
            
            Information.saveInfo()
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
      @IBAction func didPressEdit() {
           self.view.endEditing(true)
           LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"updateUserInfo",
                                                        "session":Information.token ?? "",
                                                        "name":oldPass.text as Any,
                                                        "overrideAlert":"1",
                                                        "overrideLoading":"1",
                                                        "host":self], withCache: { (cacheString) in
           }, andCompletion: { (response, errorCode, error, isValid, object) in
               let result = response?.dictionize() ?? [:]
                                                   
               if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                   self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                   return
               }
            
               self.showToast("Cập nhật thông tin thành công", andPos: 0)
               
               self.navigationController?.popViewController(animated: true)
           })
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == oldPass {
//            newPass.becomeFirstResponder()
//        } else if textField == newPass {
//            reNewPass.becomeFirstResponder()
//        } else {
//            self.view.endEditing(true)
//        }
        self.view.endEditing(true)

        return true
    }
    
    @objc func textOldIsChanging(_ textField:UITextField) {
        submit.isEnabled = oldPass.text?.count != 0
        submit.alpha = oldPass.text?.count != 0 ? 1 : 0.5
    }
    
//    @objc func textIsChanging(_ textField:UITextField) {
//        let isMatch: Bool = newPass.text?.count != 0 && reNewPass.text?.count != 0 && newPass.text == reNewPass.text
//        reNewBg.backgroundColor = isMatch ? AVHexColor.color(withHexString: "#5530F5") : .red
//        reNewPassErr.alpha = isMatch ? 0 : 1
//
//        submit.isEnabled = oldPass.text?.count != 0 && newPass.text?.count != 0 && reNewPass.text?.count != 0 && newPass.text == reNewPass.text
//        submit.alpha = oldPass.text?.count != 0 && newPass.text?.count != 0 && reNewPass.text?.count != 0 && newPass.text == reNewPass.text ? 1 : 0.5
//    }
}

extension Weather_Name_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 2 ? 191 : 94
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
