//
//  NSColor+Extension.swift
//  VSwiftMessageBox
//
//  Created by KIM vong-e on 2022/02/13.
//  Copyright (c) 2022 vong-e. All rights reserved.
//

import AppKit

extension NSColor {
    /// Get Text Color
    public static func getText(color: TextColor) -> NSColor {
        return NSColor(named: color.rawValue)!
    }
    
    /// Get Background Color
    public static func getBG(color: BackGroundColor) -> NSColor {
        return NSColor(named: color.rawValue)!
    }
    
    /// Get Border Color
    public static func getBorder(color: BorderColor) -> NSColor {
        return NSColor(named: color.rawValue)!
    }
}

// MARK: - Color Enum
public enum TextColor: String {
    case primary = "t_primary"
}

public enum BackGroundColor: String {
    case deem = "bg_deem"
    case message = "bg_message"
}

public enum BorderColor: String {
    case message = "border_message"
}
