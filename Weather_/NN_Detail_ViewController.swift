//
//  NN_Detail_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 7/24/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit
import WebKit

class NN_Detail_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var webView: WKWebView!
    
    var object: NSDictionary!
    
    var headerView: UIView!
    
    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let headerView = UIImageView()
//        headerView.image = UIImage(named: "success-baby")
//        headerView.contentMode = .scaleAspectFit
//
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_sex")
        imageView.contentMode = .scaleAspectFill
                
        //setup blur vibrant view
//        imageView.blurView.setup(style: UIBlurEffectStyle.dark, alpha: 1).enable()
                
//        headerImageView = imageView
                
//        scrollView.parallaxHeader.view = imageView
        
//        scrollView.parallaxHeader.view = imageView
//        scrollView.parallaxHeader.height = 171
//        scrollView.parallaxHeader.minimumHeight = 40
//        scrollView.parallaxHeader.mode = .centerFill
//        scrollView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
//            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
//        }
//
        let top = "<html> <head> <meta name=\"viewport\"  content=\"width=device-width, initial-scale=1, maximum-scale=1\"/><style>img { width:auto; height:auto; max-width:100%; max-height:90vh; } .wp-video-shortcode { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } .wp-video { width:auto; height:auto; max-width:100%; max-height:90vh; background-color: black; color: black; border: 1px solid black; } </style></head><body>"
               let bottom = "</body></html>"
               webView.loadHTMLString(top + object.getValueFromKey("content") + bottom, baseURL: nil)
        
//        webView.scrollView.parallaxHeader.view =
        
//        scrollView.contentSize = CGSize.init(width: CGFloat(screenWidth()), height: 8000)
//        let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 171, left: 0.0, bottom: 0, right: 0.0)
//
//        self.tableView.contentInset = collectionViewInsets
//
        
        tableView.withCell("NN_Web_Cell")

        webView.isOpaque = false
        
        self.webView.scrollView.backgroundColor = .white

                headerView = (Bundle.main.loadNibNamed("NN_Detail_Header", owner: self, options: nil)![IS_IPAD ? 0 : 0] as! UIView)

//                headerView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 1).enable()

                let back = self.withView(headerView, tag: 1) as! UIButton

                back.action(forTouch: [:]) { (obj) in
                    self.navigationController?.popViewController(animated: true)
                }

//                let read = self.withView(headerView, tag: 33) as! UIButton

//                read.action(forTouch: [:]) { (obj) in
////                    self.didRequestPackage(book: self.config)
//                }

                let title = self.withView(headerView, tag: 2) as! UILabel

                title.text = self.object.getValueFromKey("title")

        let bb = self.withView(headerView, tag: 111) as! UIView

        
        
                let avatar = self.withView(headerView, tag: 3) as! UIImageView

                avatar.imageUrl(url: self.object.getValueFromKey("thumbnail"))
//
//                let name = self.withView(headerView, tag: 4) as! UILabel
//
////                name.text = self.config.getValueFromKey("name")
//
                let description = self.withView(headerView, tag: 5) as! UILabel

                description.text = self.object.getValueFromKey("title")

        
//                let backgroundImage = self.withView(headerView, tag: 6) as! UIImageView

//                backgroundImage.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0.9).enable()

//                backgroundImage.imageUrl(url: self.config.getValueFromKey("avatar"))

                webView.scrollView.parallaxHeader.view = headerView
                webView.scrollView.parallaxHeader.height = CGFloat(250)
                webView.scrollView.parallaxHeader.minimumHeight = 64
                webView.scrollView.parallaxHeader.mode = .centerFill
                webView.scrollView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
                    back.alpha = 1 - parallaxHeader.progress
                    title.alpha = 1 - parallaxHeader.progress
                    avatar.alpha = parallaxHeader.progress
                    bb.alpha = 1 - parallaxHeader.progress
//                    name.alpha = parallaxHeader.progress
//        //            read.alpha = parallaxHeader.progress
                    description.alpha = parallaxHeader.progress
                }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.tableView.reloadData()
       })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

 extension NN_Detail_ViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return height + 100// 2232//UITableView.automaticDimension // 300
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NN_Web_Cell", for: indexPath) as! NN_Web_Cell
            
            cell.content = object.getValueFromKey("content")
            
            cell.returnValue = { value in
                self.height = CGFloat(value)
                self.tableView.reloadData()
            }
                        
//            let data = dataList[indexPath.row] as! NSDictionary
//
//            (self.withView(cell, tag: 111) as! UIView).withBorder(["Bwidth": 0, "Bcorner": 6])
//
//            (self.withView(cell, tag: 11) as! UIImageView).imageUrl(url: data.getValueFromKey("thumbnail"))
//
////            (self.withView(cell, tag: 11) as! UIImageView).heightConstaint?.constant = indexPath.row == 0 ? 197 : 0
//
//            (self.withView(cell, tag: 12) as! UILabel).text = data.getValueFromKey("title")
//
//            (self.withView(cell, tag: 14) as! UILabel).text = data.getValueFromKey("date")

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            if indexPath.row == dataList.count - 1 {
//              if self.pageIndex <= self.totalPage {
//                  self.isLoadMore = true
//                  self.didRequestData(isShow: false)
//              }
//           }
        }
    }

