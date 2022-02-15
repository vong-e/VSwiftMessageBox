//
//  MessageView.swift
//  VSwiftMessageBox
//
//  Created by vong-e on 2022/02/10.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import Cocoa

class MessageView: NSView {
    
    private let conatinerBox: NSBox = {
        let box = NSBox()
        box.boxType = .custom
        box.cornerRadius = 10
        box.borderWidth = 2
        box.borderColor = .getBorder(color: .message)
        box.fillColor = .getBG(color: .message)
        return box
    }()

    private let messageImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = NSImage(named: "bell.badge")!
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private let messageTitleTextField: NSTextField = {
        let textField = NSTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEditable = false
        textField.isBordered = false
        textField.isBezeled = false
        textField.lineBreakMode = .byTruncatingTail
        textField.backgroundColor = .clear
        textField.alignment = .left
        textField.font = .boldSystemFont(ofSize: 14)
        textField.stringValue = "Message Arrived! 💌"
        return textField
    }()
    
    private let messageSubTitleTextField: NSTextField = {
        let textField = NSTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEditable = false
        textField.isBordered = false
        textField.isBezeled = false
        textField.lineBreakMode = .byTruncatingTail
        textField.backgroundColor = .clear
        textField.alignment = .left
        textField.font = .systemFont(ofSize: 12)
        textField.stringValue = "Your Message Here."
        return textField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Create using code base")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        settingUI()
        self.settingTrackingArea()
    }
    
    private func settingUI() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.addSubview(conatinerBox)
        constraintToSuperView(childView: conatinerBox)
        
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        stackView.orientation = .horizontal
        stackView.alignment = .leading
        stackView.addArrangedSubview(messageTitleTextField)
        stackView.addArrangedSubview(messageSubTitleTextField)

        conatinerBox.addSubview(messageImageView)
        conatinerBox.addSubview(stackView)
        
        messageImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        stackView.leadingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: 8).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16).isActive = true
    }
    
    public func changeMessage(title: String, subtitle: String) {
        DispatchQueue.main.async {
            self.messageTitleTextField.stringValue = title
            self.messageSubTitleTextField.stringValue = subtitle
        }
    }
    
    private func constraintToSuperView(childView: NSView) {
        guard let superview = childView.superview else {
            return
        }

        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        childView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        childView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        childView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}

// MARK: - Tracking Area
extension MessageView {
    func settingTrackingArea() {
        if self.trackingAreas.count == 0 {
            let area = NSTrackingArea.init(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
            self.addTrackingArea(area)
        }
    }
    
    /*
     Mouse Event
     */
    override func mouseEntered(with event: NSEvent) {
        NSCursor.pointingHand.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        NSCursor.arrow.set()
    }
}
