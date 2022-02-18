//
//  VConfiguredMessage.swift
//  VSwiftMessageBox
//
//  Created by vongvorovongvong on 2022/02/17.
//

import Cocoa

class VConfiguredMessage: NSView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    var configuration: VSwiftMessageBoxConfig? = nil
    var timer: Timer?
    
    func addMessageView(message: NSView, config: VSwiftMessageBoxConfig) {
        self.configuration = config
        self.addSubview(message)
        self.wantsLayer = true
        self.layer?.cornerRadius = config.messageCornerRadius
        self.layer?.opacity = config.messageOpacity
        setTimer()
    }
    
    private func setTimer() {
        guard let config = configuration else { return }
        timer = Timer.scheduledTimer(withTimeInterval: config.showingDuration, repeats: false, block: { [weak self] time in
            guard let self = self else { return }
            print("타이머끝")
            self.removeFromSuperview()
        })
    }
                       
    public func invalidateTimer() {
        print("타이머인발리데이트")
        timer?.invalidate()
        timer = nil
    }
    
    override func removeFromSuperview() {
        print("리무브 메시지")
        invalidateTimer()
        let heightConstraints: [NSLayoutConstraint] = self.constraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.height }
        self.removeConstraints(heightConstraints)
        
        NSAnimationContext.runAnimationGroup({ [weak self] context in
            guard let self = self else { return }
            context.duration = configuration?.disappearDuration ?? 0.5
            context.allowsImplicitAnimation = true
            self.alphaValue = 0
            self.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.window?.layoutIfNeeded()
        }, completionHandler: {
            super.removeFromSuperview()
        })
    }
}
