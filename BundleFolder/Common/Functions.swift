//
//  Functions.swift
//  BundleFolder
//
//  Created by Paulo Silva on 27/07/2018.
//  Copyright © 2018 Paulo Silva. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG

func DLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    let outfilename = (filename as NSString).lastPathComponent
    NSLog("[\(outfilename):\(line)] \(function) - \(message)")
}

#else

func DLog(_ message: String, filename _: String = #file, function _: String = #function, line _: Int = #line) {}

#endif
