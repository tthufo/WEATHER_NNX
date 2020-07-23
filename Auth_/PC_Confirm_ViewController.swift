//
//  PC_Forgot_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 8/4/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

class PC_Confirm_ViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var logo: UIImageView!
    
    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var login: UIView!
    
    @IBOutlet var cover: UIView!

    @IBOutlet var phoneNo: UILabel!

    var typing: NSString!
    
    var uName: String!
    
    var kb: KeyBoard!
    
    let bottomGap = IS_IPHONE_5 ? 40.0 : 60.0

    let topGap = IS_IPHONE_5 ? 110 : 150
    
    var isValid: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kb = KeyBoard.shareInstance()
        
        self.setUp()
                
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
                        
        if Information.check == "1" {
            self.logo.image = UIImage(named: "icon_success_white")
        }
        
        phoneNo.text = uName ?? ""
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
        
        frame.origin.x = CGFloat(self.screenWidth() - 150) / 2
              
        frame.size.width = CGFloat(150)
        
        frame.size.height = CGFloat(150)
        
        logo.frame = frame
        
        logo.alpha = 1
        
        UIView.animate(withDuration: 1.5, animations: {
            self.cover.alpha = bbgg ? 0.3 : 0
        }) { (done) in
            UIView.transition(with: self.bg, duration: 1.5, options: .transitionCrossDissolve, animations: {
                self.bg.image = bbgg ? Information.bbgg!.stringImage() : UIImage(named: "bg-1")
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
    
//    func convertPhone() -> String {
//        let phone = uName
//        if phone?.substring(to: 2) == "84" {
//            return phone!
//        } else if phone?.substring(to: 1) == "0"  {
//            return "84" + (phone?.dropFirst())!
//        }
//        return phone!
//    }
    
    @IBAction func didPressBack() {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
