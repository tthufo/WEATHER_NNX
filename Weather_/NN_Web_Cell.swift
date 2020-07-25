//
//  NN_Web_Cell.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 7/24/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit
import WebKit

class NN_Web_Cell: UITableViewCell, WKNavigationDelegate {

     @IBOutlet weak var detailWebView: WKWebView!

     @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    var loaded: Bool = false
    
    var indexing: Int = 0
    
    var returnValue: ((_ value: Float)->())?

    var content: String = ""

     override func awakeFromNib() {
        super.awakeFromNib()
//        detailWebView.contentMode = .scaleToFill
        detailWebView.navigationDelegate = self
        detailWebView.scrollView.isScrollEnabled = false
             detailWebView.navigationDelegate = self
                let top = "<html> <head> <meta name=\"viewport\"  content=\"width=device-width, initial-scale=1, maximum-scale=1\"/><style>img { width:auto; height:auto; max-width:100%; max-height:90vh; } .wp-video-shortcode { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } .wp-video { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } </style></head><body>"
                let bottom = "</body></html>"
        //        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        //        detailWebView
//                detailWebView.loadHTMLString(top + content + bottom, baseURL: nil)
//        detailWebView.loadHTMLString(content, baseURL: nil)
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        detailWebView.contentMode = .scaleToFill
        detailWebView.navigationDelegate = self
        let top = "<html> <head> <meta name=\"viewport\"  content=\"width=device-width, initial-scale=1, maximum-scale=1\"/><style>img { width:auto; height:auto; max-width:100%; max-height:90vh; } .wp-video-shortcode { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } .wp-video { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } </style></head><body>"
        let bottom = "</body></html>"
        detailWebView.loadHTMLString(top + content + bottom, baseURL: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
//        webView.evaluateJavaScript(js, completionHandler: nil)
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.detailWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                self.containerHeight.constant = height as! CGFloat
                    print("height", height)
                    if self.indexing < 2 {
                        self.returnValue?(height as! Float)
                        self.indexing += 1
                    }
                })
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
