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
    
    /// Release message when clikced
    var isReleaseWhenClicked: Bool = false
    
    /// Message showing duration
    var duration: CGFloat = 2.0
    
    /// Message corner radius
    var messageCornerRadius: CGFloat = 10.0
    
    /// Message opacity
    var messageOpacity: Float = 0.9
    
//    var verticalMargin
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

let defaultConfig: VSwiftMessageBoxConfig = VSwiftMessageBoxConfig()

class VSwiftMessageBox: NSView {
    
    var configuration: VSwiftMessageBoxConfig = VSwiftMessageBoxConfig()
    
    let messageStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Create Message Box Using Code Base.")
    }
    
    
    init(frame frameRect: NSRect, config: VSwiftMessageBoxConfig = defaultConfig) {
        super.init(frame: frameRect)
        self.configuration = config
    }
    
    func setup(config: VSwiftMessageBoxConfig) {
        //셋업코드. 이스릴리즈드웬클로즈 등
//        messageStackView.alignment = config.messageBoxPosition todo. 이거 포지션으로 어케줘야할지?
        messageStackView.spacing = config.messagesSpacing
    }
    
    func addMessage(view: NSView) {
        view.wantsLayer = true
        view.layer?.cornerRadius = configuration.messageCornerRadius
        view.layer?.opacity = configuration.messageOpacity
        
        if configuration.isAllowMultipleMessages {
            messageStackView.addArrangedSubview(view)
        } else {
            messageStackView.subviews.removeAll()
            messageStackView.addArrangedSubview(view)
        }
    }
}
