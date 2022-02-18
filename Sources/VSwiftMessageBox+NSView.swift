//
//  VSwiftMessageBox.swift
//  Pods-VSwiftMessageBox_Example
//
//  Created by vong-e on 2022/02/01.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import Cocoa

/*
 VSwiftMessageBox Config
 */
public struct VSwiftMessageBoxConfig {
    /// Messgebox postion
    public var messageBoxPosition: MessageBoxPosition = .bottomTrailing
    
    /// Messages spacing
    public var messagesSpacing: CGFloat = 10
    
    /// MessageBox allows multiple messages
    public var isAllowMultipleMessages: Bool = true
        
    /// Release message when clicked.
    ///
    /// if true -> message release when clicked
    /// if false -> message not release when clicked (message remains during duration)
    public var isReleaseWhenClicked: Bool = true
    
    /// Message's Timer exist or not
    /// if true -> messsage will remove after showing duration
    /// if false -> message not removed after showing duration.
    public var isTimerExist: Bool = true
    
    /// Message showing duration
    public var showingDuration: Double = 3.0
    
    /// Message appear animation duration
    public var appearDuration: Double = 1//todo. 이거쓰이나??
    
    /// Message disappear animation duration
    public var disappearDuration: Double = 1
    
    /// Message corner radius
    public var messageCornerRadius: CGFloat = 10.0
    
    /// Message opacity
    public var messageOpacity: Float = 0.9
    
    /// Deem Color
    public var deemColor: NSColor = NSColor.clear //todo. 다크모드 지원한다는거 예시로 보여주기
    
    /// Vertical Margin
    public var verticalMargin: CGFloat = 10
    
    /// Horizontal Margin
    public var horizontalMargin: CGFloat = 10
    
    public init(messageBoxPosition: MessageBoxPosition, messageSpacing: CGFloat, isAllowMultipleMessages: Bool, isReleaseWhenClicked: Bool, isTimerExist: Bool, showingDuration: CGFloat, appearDuration: CGFloat, disappearDuration: CGFloat, messageCornerRadius: CGFloat, messageOpacity: Float, deemColor: NSColor, verticalMargin: CGFloat, horizontalMargin: CGFloat) {
        self.messageBoxPosition = messageBoxPosition
        self.messagesSpacing = messageSpacing
        self.isAllowMultipleMessages = isAllowMultipleMessages
        self.isReleaseWhenClicked = isReleaseWhenClicked
        self.showingDuration = showingDuration
        self.appearDuration = appearDuration
        self.disappearDuration = disappearDuration
        self.messageCornerRadius = messageCornerRadius
        self.messageOpacity = messageOpacity
        self.deemColor = deemColor
        self.verticalMargin = verticalMargin
        self.horizontalMargin = horizontalMargin
    }
}

public enum MessageBoxPosition: String, CaseIterable {
    case topLeading
    case topCenter
    case topTrailing
    
    case center
    
    case bottomLeading
    case bottomCenter
    case bottomTrailing
}

/// Default VSwiftMessageBogConfig value
public let defaultConfig = VSwiftMessageBoxConfig(messageBoxPosition: .bottomTrailing, messageSpacing: 10, isAllowMultipleMessages: true, isReleaseWhenClicked: true, isTimerExist: true, showingDuration: 3, appearDuration: 1, disappearDuration: 1, messageCornerRadius: 10, messageOpacity: 0.9, deemColor: .clear, verticalMargin: 10, horizontalMargin: 10)
private let messageContainerIdentifier: String = "VSwiftMessageContainer"
private let messageStackViewIdentifier: String = "VSwiftMessageStackView"

public extension NSView {
    func addMessage(messageView: NSView, config: VSwiftMessageBoxConfig = defaultConfig) {
        let message = getConfiguredMessage(message: messageView, config: config)
        message.widthAnchor.constraint(equalToConstant: messageView.frame.width).isActive = true
        message.heightAnchor.constraint(equalToConstant: messageView.frame.height).isActive = true
        
        /// 1. Get message container box
        let containerBox = getMessageContainerBox(config: config)
        
        /// 2. Get message stackview
        let messageStackView = getMessageStackView(messageBox: containerBox, config: config)
        
        /// 3. Setting messagebox position (constraint, alignment)
        setMessageBoxPosition(container: containerBox, messageStackView: messageStackView, config: config)
      
        if config.isAllowMultipleMessages {
            print("allow multiple messages")
            messageStackView.addArrangedSubview(message)
            message.alphaValue = 0
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = config.appearDuration
                // Use the value you want to animate to (NOT the starting value)
//                self.basicButton.animator().alphaValue = 0
                message.animator().alphaValue = 1
              })
        } else {
            print("not allow multiple messages")
            print("stackview's subviews: \(messageStackView.subviews)")
            messageStackView.subviews.removeAll()
            messageStackView.addArrangedSubview(message)
            message.alphaValue = 0
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = config.appearDuration
                // Use the value you want to animate to (NOT the starting value)
//                self.basicButton.animator().alphaValue = 0
                message.animator().alphaValue = 1
              })
        }
        
        print("==> stackview's subviews: \(messageStackView.subviews)")
        
        /// Add click getsure
        let clickGesture = NSClickGestureRecognizer(target: message, action: #selector(NSView.releaseWhenClickedGesture(_:)))
        message.addGestureRecognizer(clickGesture)
    }
    
    /*
     1. Get message container box
     */
    fileprivate func getMessageContainerBox(config: VSwiftMessageBoxConfig) -> NSBox {
        guard let containerBox = findSubView(in: self, accessibilityIdentifier: messageContainerIdentifier) as? NSBox else {
            let container = NSBox()
            container.setAccessibilityIdentifier(messageContainerIdentifier)
            container.boxType = .custom
            container.borderWidth = 0
            container.cornerRadius = 0
            container.fillColor = config.deemColor
            
            self.addSubview(container)
            container.constraintToSuperview()
            return container
        }
        
        return containerBox
    }
    
    /*
     2. Get message stackview
     */
    fileprivate func getMessageStackView(messageBox: NSView, config: VSwiftMessageBoxConfig) -> NSStackView {
        guard let messageStackView = findSubView(in: self, accessibilityIdentifier: messageStackViewIdentifier) as? NSStackView else {
            let messageStackView = NSStackView()
            messageStackView.setAccessibilityIdentifier(messageStackViewIdentifier)
            messageStackView.orientation = .vertical
            messageStackView.alignment = .trailing
            messageStackView.distribution = .fill
            messageStackView.spacing = config.messagesSpacing
            
            messageBox.addSubview(messageStackView)
            return messageStackView
        }
            
        return messageStackView
    }
    
    /*
     3. Setting messagebox position (constraint, alignment)
     */
    fileprivate func setMessageBoxPosition(container: NSBox, messageStackView: NSStackView, config: VSwiftMessageBoxConfig) {
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let vMargin = config.verticalMargin
        let hMargin = config.horizontalMargin
        
        switch config.messageBoxPosition {
        case .topLeading:
            messageStackView.alignment = .leading
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .topCenter:
            messageStackView.alignment = .centerX
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
        
        case .topTrailing:
            messageStackView.alignment = .trailing
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -vMargin).isActive = true
            
        case .center:
            messageStackView.alignment = .centerX
            messageStackView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            messageStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            
        case .bottomLeading:
            messageStackView.alignment = .leading
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomCenter:
            messageStackView.alignment = .centerX
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomTrailing:
            messageStackView.alignment = .trailing
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -vMargin).isActive = true
        }
    }
    
    /// Make message view with configuration
    fileprivate func getConfiguredMessage(message: NSView, config: VSwiftMessageBoxConfig) -> VConfiguredMessage {
        let vMessage = VConfiguredMessage(frame: message.frame)
        vMessage.addMessageView(message: message, config: config)
        return vMessage
    }
    
    /// Scan all subviews and find view with accessibilityIdentifier
    fileprivate func findSubView(in view: NSView, accessibilityIdentifier: String) -> NSView? {
        for i in 0..<view.subviews.count {
            if view.subviews[i].accessibilityIdentifier() == accessibilityIdentifier {
                return view.subviews[i]
            }
            if let targetView = findSubView(in: view.subviews[i], accessibilityIdentifier: accessibilityIdentifier) {
                return targetView
            }
        }
        return nil
    }
    
    
    @objc func releaseWhenClickedGesture(_ recognizer: NSClickGestureRecognizer) {
        guard let targetView = recognizer.target as? VConfiguredMessage else {
            return
        }
        
        if targetView.configuration.isReleaseWhenClicked {
            targetView.removeAllGestureRecognizers()
            removeMessage(message: targetView)
        }
    }

    /// Remove all gesture recognizers
    fileprivate func removeAllGestureRecognizers() {
        self.gestureRecognizers.removeAll()
    }
    
    /// Remove Message
    fileprivate func removeMessage(message: VConfiguredMessage) {
        print("Remove message: \(message)")
        
        message.removeMessage {
            print("메시지 리무브드")
            let messageCount: Int = self.getMessageCount()

            if messageCount == 0 {
                self.releaseVSwiftMessageBox()
            }
        }
    }
    
    /// Get message box's message count
    func getMessageCount() -> Int {
        guard let mainView = NSApplication.shared.keyWindow?.contentViewController?.view else {
            return 0
        }
        
        guard let messageStackView = findSubView(in: mainView, accessibilityIdentifier: messageStackViewIdentifier) as? NSStackView else {
            return 0
        }
        return messageStackView.subviews.count
    }
    
    /// Release VSwiftMessageBox
    func releaseVSwiftMessageBox() {
        guard let mainView = NSApplication.shared.keyWindow?.contentViewController?.view else {
            return
        }
        
        guard let containerBox = findSubView(in: mainView, accessibilityIdentifier: messageContainerIdentifier) as? NSBox else {
            return
        }
        
        containerBox.removeFromSuperview()
    }
    
    /// Constraint fit to superview if exist
    fileprivate func constraintToSuperview() {
        guard let superview = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}

func disappearWithAnimation(message: NSView, duration: Double, delay: Double = 0, completion: @escaping () -> ()) {
    message.wantsLayer = true
    guard let layer = message.layer else {
        return
    }

    CATransaction.begin()
    CATransaction.setCompletionBlock {
        completion()
    }
    let appearAnimataion = CABasicAnimation(keyPath: "opacity")
    appearAnimataion.beginTime = CACurrentMediaTime() + delay
    appearAnimataion.duration = duration
    appearAnimataion.fromValue = 1
    appearAnimataion.toValue = 0
    appearAnimataion.fillMode = CAMediaTimingFillMode.both
    layer.add(appearAnimataion, forKey: "nil")
    message.alphaValue = 0
    CATransaction.commit()
}
