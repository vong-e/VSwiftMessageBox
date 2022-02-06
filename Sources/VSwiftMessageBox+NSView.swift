//
//  VSwiftMessageBox.swift
//  Pods-VSwiftMessageBox_Example
//
//  Created by vongvorovongvong on 2022/02/01.
//

import Cocoa

/*
 VSwiftMessageBox Config
 */
public struct VSwiftMessageBoxConfig {
    /// Messgebox postion
    var messageBoxPosition: MessageBoxPosition = .bottomRight
    
    /// Messages spacing
    var messagesSpacing: CGFloat = 10
    
    /// MessageBox allows multiple messages
    var isAllowMultipleMessages: Bool = false
    
        
    /// Release message when clicked.
    ///
    /// if true -> message release when clicked
    /// if false -> message not release when clicked (message remains during duration)
     
    var isReleaseWhenClicked: Bool = true
    
    /// Message showing duration
    var duration: CGFloat = 2.0
    
    /// Message corner radius
    var messageCornerRadius: CGFloat = 10.0
    
    /// Message opacity
    var messageOpacity: Float = 0.9
    
//    var verticalMargin
    
    public init() {}
}

enum MessageBoxPosition {
    case topLeft
    case topCenter
    case topRight
    
    case center
    
    case bottomLeft
    case bottomCenter
    case bottomRight
}

public extension NSView {
    func addMessage(messageView: NSView, config: VSwiftMessageBoxConfig = VSwiftMessageBoxConfig()) {
        print("애드메시지")
        let message = getConfiguredMessage(message: messageView, config: config)
        message.widthAnchor.constraint(equalToConstant: messageView.frame.width).isActive = true
        message.heightAnchor.constraint(equalToConstant: messageView.frame.height).isActive = true
        
        let messageStackView = NSStackView()
        messageStackView.orientation = .vertical
        messageStackView.alignment = .trailing
        messageStackView.distribution = .fill
        messageStackView.spacing = config.messagesSpacing
        
        if config.isAllowMultipleMessages {
            messageStackView.addArrangedSubview(message)
        } else {
            messageStackView.subviews.removeAll()
            messageStackView.addArrangedSubview(message)
        }
        
        if config.isReleaseWhenClicked {
            print("이즈릴리즈웬클릭")
            let clickGesture = NSClickGestureRecognizer(target: message, action: #selector(NSView.releaseWhenClickedGesture(_:)))
            message.addGestureRecognizer(clickGesture)
        } else {
            print("이즈 낫 릴리즈웬클릭")
        }
        
        addSubview(messageStackView)
        
        switch config.messageBoxPosition {
        default:
            messageStackView.setBottomRightConstraint()
        }
    }
    
    /// Make message view with configuration
    fileprivate func getConfiguredMessage(message: NSView, config: VSwiftMessageBoxConfig) -> NSView {
        message.wantsLayer = true
        message.layer?.cornerRadius = config.messageCornerRadius
        message.layer?.opacity = config.messageOpacity
        
        return message
    }
    
    fileprivate func setBottomRightConstraint() {
        print(#function)
        guard let superview = self.superview else {
            print("Superview is not exist.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
    
    @objc func releaseWhenClickedGesture(_ recognizer: NSClickGestureRecognizer) {
        guard let targetView = recognizer.target as? NSView else {
            print("target not found")
            return
        }
        
        print("메시지 클릭드: ", targetView)
        targetView.removeFromSuperview()
    }
    
    func removeMessage(message: NSView) {
        print("리무브메시지")
    }
}
