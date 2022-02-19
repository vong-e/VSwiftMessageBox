//
//  VConfiguredMessage.swift
//  VSwiftMessageBox
//
//  Created by vongvorovongvong on 2022/02/17.
//

import Cocoa

public class VConfiguredMessage: NSView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    var configuration: VSwiftMessageBoxConfig = VSwiftMessageBox.defaultConfig
    var timer: Timer?
    
    func addMessageView(message: NSView, config: VSwiftMessageBoxConfig) {self.configuration = config
        self.addSubview(message)
        self.wantsLayer = true
        self.layer?.cornerRadius = config.messageCornerRadius
        self.layer?.opacity = config.messageOpacity
        setTimer()
    }
    
    private func setTimer() {
        if !configuration.isTimerExist {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: configuration.showingDuration, repeats: false, block: { [weak self] time in
            guard let self = self else { return }
            self.removeMessage{
                let messageCount: Int = self.getMessageCount()

                if messageCount == 0 {
                    self.releaseVSwiftMessageBox()
                }
            }
        })
    }
                       
    public func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func removeMessage(completion: @escaping ()->()) {
        invalidateTimer()
        
        let heightConstraints: [NSLayoutConstraint] = self.constraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.height }
        self.removeConstraints(heightConstraints)
        
        guard let messageStackView: NSStackView = self.superview as? NSStackView else {
            return
        }
        messageStackView.setCustomSpacing(0, after: self)
        NSAnimationContext.runAnimationGroup({ [weak self] context in
            guard let self = self else { return }
            context.duration = configuration.disappearDuration
            context.allowsImplicitAnimation = true
            self.alphaValue = 0
            self.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.window?.layoutIfNeeded()
        }, completionHandler: {
            super.removeFromSuperview()
            completion()
        })
    }
}
