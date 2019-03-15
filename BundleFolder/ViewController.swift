//
//  ViewController.swift
//  BundleFolder
//
//  Created by Paulo Silva on 25/07/2018.
//  Copyright © 2018 Paulo Silva. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonAbout: UIButton!
    @IBOutlet weak var buttonDisclaimer: UIButton!

    @IBOutlet weak var buttonOkay: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!

    //@IBOutlet weak var webView: CWKWebView!
    
    //var countryCode = Locale.current.languageCode ?? "en_GB"
    var countryCode = AppSettings().kCountryCode

    // MARK: - View live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //webView.navigationDelegate = self
        
        // Add addScriptMessageHandler in javascript: window.webkit.messageHandlers.MyObserver.postMessage()
        //webView.configuration.userContentController.add(self, name: "messageWKScriptHandler")
        
        // DEBUG
        DLog("preferred: {")
        DLog(" languages: \(Locale.preferredLanguages),")
        DLog(" countryCode: \(self.countryCode)")
        DLog("}")
        
//        //
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            self.countryCode = countryCode
//        }
        
        // DEBUG
        DLog("preferred: {")
        DLog(" languages: \(Locale.preferredLanguages),")
        DLog(" countryCode: \(self.countryCode)")
        DLog("}")
        
        // DEBUG
        DLog("")
        
        DLog("local {")
        DLog(" autoupdatingCurrent: \(Locale.autoupdatingCurrent)")
        DLog(" Locale: \(Locale.current)")
        DLog("}")
        
        // DEBUG DATE
        DLog("Location: \(Locale.current)")
        
        //DEBUG
        DLog("")
        
        //DEBUG
        DLog("")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Comment and Uncomment the following code as you need to test
        
        // TODO: App default Localization behavior, by Apple
        //self.buttonAbout.setTitle(NSLocalizedString("kAboutTitle", comment: ""), for: .normal)
        //self.buttonDisclaimer.setTitle(NSLocalizedString("kDisclaimerTitle", comment: ""), for: .normal)
        
        // TODO: App Custom Localization base on fallback language (en), by us
        self.buttonAbout.setTitle("kAboutTitle".localizedString, for: .normal)
        self.buttonDisclaimer.setTitle("kDisclaimerTitle".localizedString, for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        //
        let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController //as! CWKWebViewController
        
        //
        DLog("Identifier: \(String(describing: segue.identifier))")
        DLog("Destination: \(String(describing: segue.destination))")
        DLog("RestorationIdentifier: \(String(describing: targetController?.restorationIdentifier))")
        
        //
        // Code below we replace this one: if targetController?.restorationIdentifier == "webViewController"
        if targetController?.restorationIdentifier == SegueTargetController.webViewController.rawValue {
            
            let webViewController = targetController as! CWKWebViewController
            webViewController.delegate = self
            
            // Code below we replace this one: if segue.identifier == "showAbout"
            if segue.identifier == SegueTargetAction.showAbout.rawValue {
                

                webViewController.displayFileNamed = "about"

                // Code below we replace this one: if segue.identifier == "showDisclaimer"
            } else if segue.identifier == SegueTargetAction.showDisclaimer.rawValue {
                
                webViewController.displayFileNamed = "disclaimer"

            }
            
        }

     }

}

extension ViewController: CWKWebViewControllerDelegate {
        
    func didReceive (message: WKScriptMessage) {
        
        let messageBody = message.body as! String;
        DLog("Message Body: \(messageBody)")
        
    }
    
}
