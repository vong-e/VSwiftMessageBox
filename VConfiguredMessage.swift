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
            self.invalidateTimer()
        })
    }
                       
    public func invalidateTimer() {
        print("타이머인발리데이트")
        timer?.invalidate()
        timer = nil
    }
}
