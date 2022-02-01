//
//  MessageBox.swift
//  Pods-VSwiftMessageBox_Example
//
//  Created by vongvorovongvong on 2022/02/01.
//

import Cocoa

enum Position {
    case topLeft
    case topCenter
    case topRight
    
    case center
    
    case bottomLeft
    case bottomCenter
    case bottomRight /// Default Position
}

class MessageBox: NSView {
    
    let messageStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    var isReleaseMessageWhenClicked: Bool = true
    
    
    init(frame frameRect: NSRect, position: Position) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConfig() {
        //셋업코드. 이스릴리즈드웬클로즈 등
    }
    
    func addMessage(view: NSView) {
        
    }
}
