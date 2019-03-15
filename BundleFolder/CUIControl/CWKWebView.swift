//
//  CWKWebView.swift
//  BundleFolder
//
//  Created by Paulo Silva on 26/07/2018.
//  Copyright © 2018 Paulo Silva. All rights reserved.
//

import UIKit
import WebKit

// NOTE: - iOS 11 only 
class CWKWebView: WKWebView {
    
    required init?(coder: NSCoder) {
        
        //
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        configuration.userContentController = controller
        
        //
        super.init(frame: CGRect.zero, configuration: configuration)
        
    }
    
}
