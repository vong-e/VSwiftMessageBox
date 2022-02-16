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
    
    /// Message showing duration
    public var showingDuration: CGFloat = 2.0
    
    /// Message appear animation duration
    public var appearDuration: CGFloat = 0.5
    
    /// Message disappear animation duration
    public var disappearDuration: CGFloat = 0.5
    
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
    
    public init(messageBoxPosition: MessageBoxPosition, messageSpacing: CGFloat, isAllowMultipleMessages: Bool, isReleaseWhenClicked: Bool, showingDuration: CGFloat, appearDuration: CGFloat, disappearDuration: CGFloat, messageCornerRadius: CGFloat, messageOpacity: Float, deemColor: NSColor, verticalMargin: CGFloat, horizontalMargin: CGFloat) {
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


public let defaultConfig = VSwiftMessageBoxConfig(messageBoxPosition: .bottomTrailing, messageSpacing: 10, isAllowMultipleMessages: true, isReleaseWhenClicked: true, showingDuration: 2, appearDuration: 0.5, disappearDuration: 0.5, messageCornerRadius: 10, messageOpacity: 0.9, deemColor: .clear, verticalMargin: 10, horizontalMargin: 10)
private let messageContainerIdentifier: String = "VSwiftMessageContainer"
private let messageStackViewIdentifier: String = "VSwiftMessageStackView"

public extension NSView {
    
    func addMessage(messageView: NSView, config: VSwiftMessageBoxConfig = defaultConfig) {
        print("애드메시지 셀프: \(self)")
        print("현재 섭뷰: \(self.subviews)")
        
        let message = getConfiguredMessage(message: messageView, config: config)
        message.widthAnchor.constraint(equalToConstant: messageView.frame.width).isActive = true
        message.heightAnchor.constraint(equalToConstant: messageView.frame.height).isActive = true
        
        /// 1. Get message container box
        let containerBox = getMessageContainerBox(config: config)
        print("가져온 컨테이너박스: \(containerBox)")
        
//        self.addSubview(containerBox)
//        containerBox.constraintToSuperview()
        
        print("애드 후 셀프섭뷰: \(self.subviews)")
        print("이즈인?? : \(findSubView(in: self, accessibilityIdentifier: messageContainerIdentifier))")
        
        /// 2. Get message stackview
        let messageStackView = getMessageStackView(messageBox: containerBox, config: config)
        
        /// 3. Setting messagebox position (constraint, alignment)
        setMessageBoxPosition(container: containerBox, messageStackView: messageStackView, config: config)
      
        if config.isAllowMultipleMessages {
            print("allow multiple messages")
            messageStackView.addArrangedSubview(message)
            message.alphaValue = 0
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = config.disappearDuration
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
                context.duration = config.disappearDuration
                // Use the value you want to animate to (NOT the starting value)
//                self.basicButton.animator().alphaValue = 0
                message.animator().alphaValue = 1
              })
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
        print("셀픕: \(self),id: \(self.accessibilityIdentifier())")
        
        guard let containerBox = findSubView(in: self, accessibilityIdentifier: messageContainerIdentifier) as? NSBox else {
            let container = NSBox()
            print("컨테이너박스 없음. 새로만들어: \(container)")
            container.setAccessibilityIdentifier(messageContainerIdentifier)
            container.boxType = .custom
            container.borderWidth = 0
            container.cornerRadius = 0
            container.fillColor = config.deemColor
            
            self.addSubview(container)
            container.constraintToSuperview()
            return container
        }
        
        print("컨테이너박스 있음: \(containerBox)")
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
            print("스택뷰 없어서 만듦: \(messageStackView)")
            
            messageBox.addSubview(messageStackView)
            return messageStackView
        }
            
        print("스택뷰 있음: \(messageStackView)")
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
//            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .topCenter:
            messageStackView.alignment = .centerX
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
//            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
        
        case .topTrailing:
            messageStackView.alignment = .trailing
            messageStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: hMargin).isActive = true
//            messageStackView.bottomAnchor.constraint(greaterThanOrEqualTo: container.bottomAnchor, constant: hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -vMargin).isActive = true
            
        case .center:
            messageStackView.alignment = .centerX
            messageStackView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            messageStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            
        case .bottomLeading:
            messageStackView.alignment = .leading
//            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomCenter:
            messageStackView.alignment = .centerX
//            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: vMargin).isActive = true
            
        case .bottomTrailing:
            messageStackView.alignment = .trailing
//            messageStackView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: hMargin).isActive = true
            messageStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -hMargin).isActive = true
            messageStackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: vMargin).isActive = true
            messageStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -vMargin).isActive = true
        }
    }
    
    /// Make message view with configuration
    fileprivate func getConfiguredMessage(message: NSView, config: VSwiftMessageBoxConfig) -> NSView {
        message.wantsLayer = true
        message.layer?.cornerRadius = config.messageCornerRadius
        message.layer?.opacity = config.messageOpacity
        
        return message
    }
    
    /// Scan all subviews and find view with accessibilityIdentifier
    fileprivate func findSubView(in view: NSView, accessibilityIdentifier: String) -> NSView? {
        print("파인드섭뷰: \(view), 섭뷰: \(view.subviews)")
        for i in 0..<view.subviews.count {
            print("\(view)의 \(i)번째 섭뷰: \(view.subviews[i])")
            if view.subviews[i].accessibilityIdentifier() == accessibilityIdentifier {
                print("찾았다. : \(view.subviews[i])")
                return view.subviews[i]
            }
            if let targetView = findSubView(in: view.subviews[i], accessibilityIdentifier: accessibilityIdentifier) {
                print("찾았다2. : \(targetView)")
                return targetView
            }
        }
        return nil
    }
    
    
    @objc func releaseWhenClickedGesture(_ recognizer: NSClickGestureRecognizer) {
        guard let targetView = recognizer.target as? NSView else {
            print("target not found")
            return
        }
        
        print("메시지 클릭드: ", targetView)
        
        targetView.removeAllGestureRecognizers()
        removeMessage(message: targetView)
    }

    /// Remove all gesture recognizers
    fileprivate func removeAllGestureRecognizers() {
        self.gestureRecognizers.removeAll()
    }
    
    /// Remove Message
    fileprivate func removeMessage(message: NSView) {
        print("리무브메시지")
        let messageHeightConstraint: NSLayoutConstraint? = message.constraints.filter {
            $0.firstAttribute == NSLayoutConstraint.Attribute.height
        }.first
        print("message height: \(messageHeightConstraint)")
        message.subviews.forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        guard let messageStackView: NSStackView = message.superview as? NSStackView else {
            return
        }
//        message.translatesAutoresizingMaskIntoConstraints = false
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            messageStackView.setCustomSpacing(0, after: message)
            message.alphaValue = 0
            message.heightAnchor.constraint(equalToConstant: 0).isActive = true
            
            self.window?.layoutIfNeeded()
        }, completionHandler: {
            print("finish")
            message.removeFromSuperview()
            
            let messageCount: Int = self.getMessageCount()
            print("남은메시지: \(messageCount)")


            if messageCount == 0 {
                print("날릴게")
                self.releaseVSwiftMessageBox()
            }
        })
    }
    
    
    
    /// Get message box's message count
    func getMessageCount() -> Int {
        guard let mainView = NSApplication.shared.keyWindow?.contentViewController?.view else {
            print("메인윈도없음")
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
            print("메인윈도없음")
            return
        }
        
        guard let containerBox = findSubView(in: mainView, accessibilityIdentifier: messageContainerIdentifier) as? NSBox else {
            print("메시지 박스 없ㄷ음")
            return
        }
        print("컨테이너제거")
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
        print("COMPLETE")
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
