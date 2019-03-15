//
//  WKWebViewViewController.swift
//  BundleFolder
//
//  Created by Paulo Silva on 02/08/2018.
//  Copyright © 2018 Paulo Silva. All rights reserved.
//

import UIKit
import WebKit

// Define the protocol
protocol CWKWebViewControllerDelegate {
    //
    func decidePolicyFor (navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    func didStartProvisional (navigation: WKNavigation!)
    func didFail (navigation: WKNavigation!, withError error: Error)
    func didFinish (navigation: WKNavigation!)
    
    //
    func didReceive (message: WKScriptMessage)
    
    //
    //func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

// Define the option methods
extension CWKWebViewControllerDelegate {
    
    //
    func decidePolicyFor (navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {}
    func didStartProvisional (navigation: WKNavigation!) {}
    func didFail (navigation: WKNavigation!, withError error: Error) {}
    func didFinish (navigation: WKNavigation!) {}
    
    //
    func didReceive (message: WKScriptMessage) {}
    
    //
    //func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {}
    
}

class CWKWebViewController: UIViewController {

    // MARK: - Public properties
    
    var displayFileNamed: String?

    // MARK: - Private properties
    
    var delegate: CWKWebViewControllerDelegate?
    
    // TODO: - Replace this with a localized file
    private let defaultDisplayFileNamed = "empty"
    
    //
    @IBOutlet weak var webView: CWKWebView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        
        // Add addScriptMessageHandler in javascript: window.webkit.messageHandlers.messageWKScriptHandler.postMessage()
        webView.configuration.userContentController.add(self, name: "messageWKScriptHandler")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        self.webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        guard self.displayFileNamed != nil else {
            
            // TODO: 1 - App default Localization behavior (Project Resource Folder)
            self.displayHtmlFileNamed(self.defaultDisplayFileNamed)
            
            return
        }
        
        // MARK: - call private localization methods for About
        
        // TODO: 1 - App default Localization behavior (Project Resource Folder)
        //self.displayHtmlFileNamed(self.displayFileNamed!)
        
        // TODO: 2 - App Custom Localization base on language fallback (en) (Project Resource Folder)
        //self.displayHtmlFileNamed(self.displayFileNamed!, withFallbackLanguage: "en")
        
        // TODO: 3 - App Custom Localization base on language fallback (en) using a bundle
        self.displayHtmlFileNamed(self.displayFileNamed!, inBundle: "Resources", withFallbackLanguage: "en")
        
        // TODO: 4 - not used, is equals to 1 (Project Resource Folder)
        //self.displayHtmlFileNamed(self.displayFileNamed!, inDirectory: "Resources")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    
    // MARK: - private localization methods
    
    enum BundleNameError: Error {
        case notFound
    }
    
    //
    private func initBundleNamed(_ bundleName: String?) throws -> Bundle {
        
        //
        guard let bundlePath = Bundle.main.path(forResource: bundleName, ofType: "bundle") else {
            throw BundleNameError.notFound
        }
        
        //
        guard let bundle = Bundle.init(path: bundlePath) else {
            throw BundleNameError.notFound
        }
        
        return bundle
    }
    
    // App Custom Localization based on language fallback (en) and use an bundle folder for the resources
    private func displayHtmlFileNamed(_ name: String, inBundle bundleName: String?, withFallbackLanguage language: String = "en", loadFile: Bool = true) {
        
        //
        var resourceBundle: Bundle
        let country = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? language
        
        do {
            
            let name = String(format: "%@_%@", bundleName!, country)
            resourceBundle = try initBundleNamed(name)
            
        } catch {
            
            do {
                
                let name = String(format: "%@_%@", bundleName!, language)
                resourceBundle = try initBundleNamed(name)
                
            } catch {
                
                return
                
            }
            
        }
        
        //
        DLog("Bundle Path: \(String(describing: resourceBundle.bundlePath))")
        if let filePath = resourceBundle.path(forResource:name, ofType:"html") {
            
            if (loadFile) {
                
                // This is the default used method
                let filePathURL = URL.init(fileURLWithPath: filePath)
                let fileDirectoryURL = filePathURL.deletingLastPathComponent()
                webView.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
                
            } else {
                
                do {
                    // TODO: - this needs more testing the default is loadFile
                    // load html string - baseURL needs to be set for local files to load correctly
                    let html = try String(contentsOfFile: filePath, encoding: .utf8)
                    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL?.appendingPathComponent((resourceBundle.bundlePath)))
                } catch {
                    DLog("Error loading html")
                }
                
            }
            
        }
        
    }
    
    // App Custom Localization base on language fallback (en)
    private func displayHtmlFileNamed(_ name: String, withFallbackLanguage language: String = "en", loadFile: Bool = true) {
        
        //
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? language
        DLog("Country Code: \(countryCode)")
        
        // System Default Language
        var bundle: Bundle? = Bundle.main
        if let userPath = Bundle.main.path(forResource: countryCode, ofType: "lproj") {
            
            // User Default Language
            bundle = Bundle(path: userPath)
            
        } else {
            
            if let fallbackPath = Bundle.main.path(forResource: language, ofType: "lproj") {
                
                // System Fallback Language
                bundle = Bundle(path: fallbackPath)
                
            }
            
        }
        
        //
        // Bundle.main.path(forResource:name, ofType:"html")
        if let filePath = bundle?.path(forResource:name, ofType:"html") {
            
            if (loadFile) {
                
                //
                let filePathURL = URL.init(fileURLWithPath: filePath)
                let fileDirectoryURL = filePathURL.deletingLastPathComponent()
                webView.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
                
            } else {
                
                do {
                    
                    // load html string - baseURL needs to be set for local files to load correctly
                    let html = try String(contentsOfFile: filePath, encoding: .utf8)
                    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                    
                } catch {
                    DLog("Error loading html")
                }
                
            }
            
        }
        
    }
    
    // App default Localization behavior, this is Apple Mode
    private func displayHtmlFileNamed(_ name: String, loadFile: Bool = false ) {
        
        //
        if let filePath = Bundle.main.path(forResource:name, ofType:"html") {
            
            if (loadFile) {
                
                //
                let filePathURL = URL.init(fileURLWithPath: filePath)
                let fileDirectoryURL = filePathURL.deletingLastPathComponent()
                webView.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
                
            } else {
                
                do {
                    
                    // load html string - baseURL needs to be set for local files to load correctly
                    let html = try String(contentsOfFile: filePath, encoding: .utf8)
                    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                    
                } catch {
                    DLog("Error loading html")
                }
                
            }
            
        }
        
    }
    
    // TODO: - I'm not using this, need to perform more tests before start using
    private func displayHtmlFileNamed(_ name: String, inDirectory directoryName: String?, loadFile: Bool = false) {
        
        //
        if let filePath = Bundle.main.path(forResource:name, ofType:"html", inDirectory: directoryName ?? "Resources_pt-PT") {
            
            if (loadFile) {
                
                //
                let filePathURL = URL.init(fileURLWithPath: filePath)
                let fileDirectoryURL = filePathURL.deletingLastPathComponent()
                webView.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
                
            } else {
                
                do {
                    
                    // load html string - baseURL needs to be set for local files to load correctly
                    let html = try String(contentsOfFile: filePath, encoding: .utf8)
                    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL?.appendingPathComponent("WebResources"))
                    
                } catch {
                    DLog("Error loading html")
                }
                
            }
            
        }
        
    }
    
    /*
    // MARK: - Javascript wrapper
    
    // TODO: - This is for testing the WKWebView isn't necessary for anything else
    @IBAction func actionJavascriptTapped(_ sender: UIButton) {
        
        let script = "testJS()"
        
        webView.evaluateJavaScript(script) { (result: Any?, error: Error?) in
            
            if let error = error {
                
                DLog("evaluateJavaScript error: \(error.localizedDescription)")
                
            } else {
                
                DLog("evaluateJavaScript result: \(result ?? "")")
                
            }
            
        }
        
    }
     */
    
}

// MARK: - WKWebView Implementation methods and delegates
// TODO: - Work in progress for use on the future apps
extension CWKWebViewController : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //
        if let delegate = self.delegate {
            delegate.didReceive (message: message)
            //delegate.userContentController(userContentController, didReceive: message)
        }
        
#if DEBUG_
        
        // Callback from javascript: window.webkit.messageHandlers.messageWKScriptHandler.postMessage(message)
        let messageBody = message.body as! String;
        let alertController = UIAlertController(title: "Html2NativeApp Message:", message: messageBody, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            DLog("OK")
        }
        alertController.addAction(okAction)
        
        //
        present(alertController, animated: true, completion: nil)
        
#endif
        
    }
    
}

extension CWKWebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //
        if let delegate = self.delegate {
            delegate.decidePolicyFor (navigationAction: navigationAction , decisionHandler: decisionHandler)
        }
        
        //
        var action: WKNavigationActionPolicy?
        
        //
        defer {
            decisionHandler(action ?? .allow)
        }
        
        //
        guard let url = navigationAction.request.url else {
            return
        }
        
        DLog("Perfix: \(url.absoluteString.hasPrefix(""))")
        
        // review this action
        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("http://www.example.com/open-in-safari") {
            
            // Stop in WebView
            action = .cancel
            
            // Open in Safari
            //UIApplication.shared.openURL(url)
            if let nUrl = URL(string: "\(url)") {
                UIApplication.shared.open(nUrl, options: [:], completionHandler: nil)
            }
            
        }
        
        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("wkwv:javaScriptCall:") {
            
            // Stop in WebView
            action = .cancel
            
            // Execute the Action
            DLog("Url: \(url.absoluteString)")
            
        }
        
        /**/
        //ecisionHandler(.allow)
        //ecisionHandler(.cancel)
        /**/
        
        /*
         func didStartProvisional (navigation: WKNavigation!)
         func didFail (navigation: WKNavigation!, withError error: Error)
         func didFinish (navigation: WKNavigation!)
         */
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DLog(String(describing: webView.url))
        
        //
        if let delegate = self.delegate {
            delegate.didStartProvisional (navigation: navigation!)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        //
        if let delegate = self.delegate {
            delegate.didFail (navigation: navigation!, withError: error)
        }
        
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("404 - Page Not Found", baseURL: URL(string: "http://www.localhost.com/"))
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DLog(String(describing: webView.url))
        
        //
        if let delegate = self.delegate {
            delegate.didFinish (navigation: navigation!)
        }
        
    }
    
}


