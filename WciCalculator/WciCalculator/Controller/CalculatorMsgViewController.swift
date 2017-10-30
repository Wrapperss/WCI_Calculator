//
//  CalculatorMsgViewController.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import UIKit
import SnapKit

class CalculatorMsgViewController: UIViewController {
    
    let webView = UIWebView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "计算公式"
        let request = NSURLRequest(url: URL(string: "http://www.gsdata.cn/site/usage")!)
        webView.loadRequest(request as URLRequest)
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}
