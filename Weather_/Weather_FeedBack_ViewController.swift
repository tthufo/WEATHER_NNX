//
//  Weather_FeedBack_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class Weather_FeedBack_ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    
    @IBOutlet var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.inputAccessoryView = self.toolBar()

        self.view.action(forTouch: [:]) { (objc) in
            self.view.endEditing(true)
        }
    }
    
    @IBAction func didUpdateFeedBack() {
          LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"updateFeedback",
                                                      "feedback":textView.text ?? "",
                                                      "session":Information.token ?? "",
                                                      "overrideAlert":"1",
                                                      "overrideLoading":"1",
                                                      "host":self], withCache: { (cacheString) in
          }, andCompletion: { (response, errorCode, error, isValid, object) in
              let result = response?.dictionize() ?? [:]
                                                  
              if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                  self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                  return
              }
                                 
            self.showSVHUD("Đã gửi phản hồi", andOption: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.hideSVHUD()
                self.navigationController?.popViewController(animated: true)
            })
        })
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
    
    func textViewDidChange(_ textView: UITextView) {
        submit.isEnabled = textView.text?.count != 0
        submit.alpha = textView.text?.count != 0 ? 1 : 0.5
    }
    
    @IBAction func didPressBack() {
       self.view.endEditing(true)
       self.navigationController?.popViewController(animated: true)
    }
}
