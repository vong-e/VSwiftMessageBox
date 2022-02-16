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
    @IBOutlet weak var positionPopUpButton: NSPopUpButton!
    
    @IBOutlet weak var messageArea: NSBox! /// Message Area
    
    @IBOutlet weak var allowMultipleMessagesCheckBox: NSButton!
    
    @IBOutlet weak var isReleaseWhenClickedCheckBox: NSButton!
    
    private var messageBoxConfig: VSwiftMessageBoxConfig = VSwiftMessageBox.defaultConfig
    private var messagePosition: MessageBoxPosition = .bottomTrailing
    private var messageCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPositionPopUpButton()
        allowMultipleMessagesCheckBox.action = #selector(allowMultipleMeesages(sender:))
        isReleaseWhenClickedCheckBox.action = #selector(isReleaseWhenClicked(sender:))
    }
    
    func initPositionPopUpButton() {
        positionPopUpButton.target = self
        positionPopUpButton.removeAllItems()
        let positionList: [String] = MessageBoxPosition.allCases.map{$0.rawValue}
        positionPopUpButton.addItems(withTitles: positionList)
        positionPopUpButton.action = #selector(positionPopUpButtonAction(_:))
        positionPopUpButton.selectItem(withTitle: MessageBoxPosition.bottomTrailing.rawValue)
    }
    @objc func positionPopUpButtonAction(_ sender: NSPopUpButton) {
        let position: MessageBoxPosition = MessageBoxPosition.init(rawValue: sender.title) ?? .bottomTrailing
        self.messagePosition = position
        print("* Position Changed: \(position)")
        NSView().releaseVSwiftMessageBox()
        self.messageCount = 0
        self.positionPopUpButton.selectItem(withTitle: position.rawValue)
    }
    
    @IBAction func addMessageButtonAction(_ sender: NSButton) {
        print("* Add Message")
        let messageView = MessageView(frame: NSRect(x: 0, y: 0, width: 300, height: 60))
        messageView.changeMessage(title: "Message Arrived! 💌", subtitle: "Your Message Here. \(messageCount)")
        messageBoxConfig.deemColor = .red
        messageBoxConfig.messageBoxPosition = self.messagePosition
        
        messageArea.addMessage(messageView: messageView, config: messageBoxConfig)
        messageCount += 1
    }
    
    @objc func allowMultipleMeesages(sender: NSButton) {
        if sender.state == .on {
            print("* Allow multiple messages.")
        } else {
            print("* Disallow multiple messages.")
        }
        NSView().releaseVSwiftMessageBox()
        self.messageCount = 0
        messageBoxConfig.isAllowMultipleMessages = (sender.state == .on)
    }
    
    @objc func isReleaseWhenClicked(sender: NSButton) {
        if sender.state == .on {
            print("* Message release when clicked.")
        } else {
            print("* Message not release when clicked.")
        }
        NSView().releaseVSwiftMessageBox()
        self.messageCount = 0
        messageBoxConfig.isReleaseWhenClicked = (sender.state == .on)
    }
}

