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
    
    /// Deem Color
    var deemColor: NSColor = NSColor.clear
    
    /// Vertical Margin
    var verticalMargin: CGFloat = 10
    
    /// Horizontal Margin
    var horizontalMargin: CGFloat = 10
    
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

private let messageContainerIdentifier: String = "VSwiftMessageContainer"
private let messageStackViewIdentifier: String = "VSwiftMessageStackView"

public extension NSView {
    
    func addMessage(messageView: NSView, config: VSwiftMessageBoxConfig = VSwiftMessageBoxConfig()) {
        print("애드메시지")
        let message = getConfiguredMessage(message: messageView, config: config)
        message.widthAnchor.constraint(equalToConstant: messageView.frame.width).isActive = true
        message.heightAnchor.constraint(equalToConstant: messageView.frame.height).isActive = true
        
        /// 1. Get message container box
        let containerBox = NSView().getMessageContainerBox(config: config)
        addSubview(containerBox)
        containerBox.constraintToSuperview()
        
        /// 2. Get message stackview
        let messageStackView = NSView().getMessageStackView(config: config)
        
        /// 3. Setting messagebox position (constraint, alignment)
        setMessageBoxPosition(container: containerBox, messageStackView: messageStackView, config: config)
      
        /// 4. isnet
        
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
        
        switch config.messageBoxPosition { //todo. 포지션별 컨스트레인트
        default:
            messageStackView.setBottomRightConstraint()
        }
    }
    
    
    /*
     1. Get message container box
     */
    fileprivate func getMessageContainerBox(config: VSwiftMessageBoxConfig) -> NSBox {
        guard let containerBox: NSBox = self.subviews.filter({$0.accessibilityIdentifier() == messageContainerIdentifier}).first as? NSBox else {
            let container = NSBox()
            container.setAccessibilityIdentifier(messageContainerIdentifier)
            container.boxType = .custom
            container.borderWidth = 0
            container.cornerRadius = 0
            container.fillColor = config.deemColor
            return container
        }
        
        return containerBox
    }
    
    /*
     2. Get message stackview
     */
    fileprivate func getMessageStackView(config: VSwiftMessageBoxConfig) -> NSStackView {
        guard let messageStackView: NSStackView = self.subviews.filter({$0.accessibilityIdentifier() == messageStackViewIdentifier}).first as? NSStackView else {
            let messageStackView = NSStackView()
            messageStackView.orientation = .vertical
            messageStackView.alignment = .trailing
            messageStackView.distribution = .fill
            messageStackView.spacing = config.messagesSpacing
            
            return messageStackView
        }
        
        return messageStackView
    }
    
    /*
     3. Setting messagebox position (constraint, alignment)
     */
    fileprivate func setMessageBoxPosition(container: NSBox, messageStackView: NSStackView, config: VSwiftMessageBoxConfig) {
        container.addSubview(messageStackView)
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        messageStackView.edgeInsets = config.messageBoxEdgeInsets //todo. 이거 제대로 먹히나 테스트
        
        switch config.messageBoxPosition {
        case .topLeft:
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        case .topCenter:
            <#code#>
        case .topRight:
            <#code#>
        case .center:
            <#code#>
        case .bottomLeft:
            <#code#>
        case .bottomCenter:
            <#code#>
        case .bottomRight:
            <#code#>
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
