//
//  AppDelegate.swift
//  VSwiftMessageBox
//
//  Created by vong-e on 02/01/2022.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import Cocoa
import VSwiftMessageBox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
      test().printTest()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

