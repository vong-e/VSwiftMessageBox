//
//  ViewController.swift
//  VSwiftMessageBox
//
//  Created by vong-e on 02/01/2022.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import Cocoa

import VSwiftMessageBox

class ViewController: NSViewController {
    @IBOutlet weak var messageArea: NSBox! /// Message Area
    
    @IBOutlet weak var allowMultipleMessagesCheckBox: NSButton!
    
    @IBOutlet weak var isReleaseWhenClickedCheckBox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowMultipleMessagesCheckBox.action = #selector(allowMultipleMeesages(sender:))
        isReleaseWhenClickedCheckBox.action = #selector(isReleaseWhenClicked(sender:))
        
    }
    
    
    @IBAction func addMessageButtonAction(_ sender: NSButton) {
//        print("* Add Message")
//        let view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 30))
//        view.wantsLayer = true
//        view.layer?.backgroundColor = NSColor.red.cgColor
//        messageArea.addMessage(messageView: view)
//        print("섭뷰: \(self.view.subviews)")
//        self.view.subviews.forEach { subview in
//            print("SUBVIew: \(subview.accessibilityIdentifier()).")
//            if subview.accessibilityIdentifier() == "VSwiftMessageContainer" {
//                print("있댜ㅏ!")
//            }
//        }
//
        
    }
    
    @objc func allowMultipleMeesages(sender: NSButton) {
        if sender.state == .on {
            print("* Allow multiple messages.")
            
        } else {
            print("* Disallow multiple messages.")
        }
    }
    
    @objc func isReleaseWhenClicked(sender: NSButton) {
        if sender.state == .on {
            print("* Message release when clicked.")
        } else {
            print("* Message not release when clicked.")
        }
    }
}

