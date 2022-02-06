//
//  ViewController.swift
//  VSwiftMessageBox
//
//  Created by vong-e on 02/01/2022.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var allowMultipleMessagesCheckBox: NSButton!
    
    @IBOutlet weak var isReleaseWhenClickedCheckBox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowMultipleMessagesCheckBox.action = #selector(allowMultipleMeesages(sender:))
        isReleaseWhenClickedCheckBox.action = #selector(isReleaseWhenClicked(sender:))
    }
    
    @IBAction func addMessageButtonAction(_ sender: NSButton) {
        print("* Add Message")
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

