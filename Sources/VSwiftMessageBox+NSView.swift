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
        print("애드메시지 셀프: \(self)")
        print("현재 섭뷰: \(self.subviews)")
        let message = getConfiguredMessage(message: messageView, config: config)
        message.widthAnchor.constraint(equalToConstant: messageView.frame.width).isActive = true
        message.heightAnchor.constraint(equalToConstant: messageView.frame.height).isActive = true
        
        /// 1. Get message container box
        let containerBox = getMessageContainerBox(config: config)
        print("가져온 컨테이너박스: \(containerBox)")
        self.addSubview(containerBox)todo. 했는데 왜 추가안되는거지?
        
        print("애드 후 셀프섭뷰: \(self.subviews)")
        print("containerbox: \(containerBox)")
        containerBox.constraintToSuperview()
        
        /// 2. Get message stackview
        let messageStackView = getMessageStackView(config: config)
        
        /// 3. Setting messagebox position (constraint, alignment)
        setMessageBoxPosition(container: containerBox, messageStackView: messageStackView, config: config)
      
        if config.isAllowMultipleMessages {
            print("allow multiple messages")
            messageStackView.addArrangedSubview(message)
        } else {
            print("not allow multiple messages")
            print("stackview's subviews: \(messageStackView.subviews)")
            messageStackView.subviews.removeAll()
            messageStackView.addArrangedSubview(message)
        }
        
        print("==> stackview's subviews: \(messageStackView.subviews)")
        
        
        if config.isReleaseWhenClicked {
            print("이즈릴리즈웬클릭")
            let clickGesture = NSClickGestureRecognizer(target: message, action: #selector(NSView.releaseWhenClickedGesture(_:)))
            message.addGestureRecognizer(clickGesture)
        } else {
            print("이즈 낫 릴리즈웬클릭")
        }
        
//        addSubview(messageStackView)
    }
    
    
    /*
     1. Get message container box
     */
    fileprivate func getMessageContainerBox(config: VSwiftMessageBoxConfig) -> NSBox {
        print("셀픕: \(self)")
        print("섭뷰스: \(self.subviews.forEach{$0.accessibilityIdentifier()})")
        guard let containerBox: NSBox = self.subviews.filter({$0.accessibilityIdentifier() == messageContainerIdentifier}).first as? NSBox else {
            let container = NSBox()
            print("컨테이너박스 없음. 새로만들어: \(container)")
            container.setAccessibilityIdentifier(messageContainerIdentifier)
            container.boxType = .custom
            container.borderWidth = 0
            container.cornerRadius = 0
            container.fillColor = NSColor.blue// config.deemColor
            return container
        }
        print("컨테이너박스 있음: \(containerBox)")
        return containerBox
    }
    
    /*
     2. Get message stackview
     */
    fileprivate func getMessageStackView(config: VSwiftMessageBoxConfig) -> NSStackView {
        guard let messageStackView: NSStackView = self.subviews.filter({$0.accessibilityIdentifier() == messageStackViewIdentifier}).first as? NSStackView else {
            let messageStackView = NSStackView()
            messageStackView.setAccessibilityIdentifier(messageStackViewIdentifier)
            messageStackView.orientation = .vertical
            messageStackView.alignment = .trailing
            messageStackView.distribution = .fill
            messageStackView.spacing = config.messagesSpacing
            print("스택뷰 없어서 만듦: \(messageStackView)")
            return messageStackView
        }
        print("스택뷰 있음: \(messageStackView)")
        return messageStackView
    }
    
    /*
     3. Setting messagebox position (constraint, alignment)
     */
    fileprivate func setMessageBoxPosition(container: NSBox, messageStackView: NSStackView, config: VSwiftMessageBoxConfig) {
        container.addSubview(messageStackView)
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let vMargin = config.verticalMargin
        let hMargin = config.horizontalMargin
        
        switch config.messageBoxPosition {
        case .topLeft:
            messageStackView.alignment = .leading
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .topCenter:
            messageStackView.alignment = .centerX
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
        
        case .topRight:
            messageStackView.alignment = .trailing
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .center:
            messageStackView.alignment = .centerX
            messageStackView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            messageStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            
        case .bottomLeft:
            messageStackView.alignment = .leading
            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomCenter:
            messageStackView.alignment = .centerX
            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomRight:
            messageStackView.alignment = .trailing
            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
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
//        targetView.removeFromSuperview()
        self.removeMessage(message: targetView)
    }
    
    fileprivate func removeMessage(message: NSView) {
        print("리무브메시지")
        message.removeFromSuperview()
        /// todo. 메시지 개수 0되면 메시지박스 날려버리기
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
