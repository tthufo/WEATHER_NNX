//
//  PC_Web_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/18/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import WebKit

class PC_Web_ViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var titleString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString ?? ""
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: titleString == "Dịch vụ MeWeather" ? "dv" : "bm", ofType: "docx")!)

        webView.load(URLRequest(url: fileURL))
    }
    
     @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
     }
}
