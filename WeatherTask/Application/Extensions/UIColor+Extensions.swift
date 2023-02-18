//
//  UIColor+Extensions.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        var hex = hex.hasPrefix("#")
        ? String(hex.dropFirst())
        : hex
        
        guard hex.count == 3 || hex.count == 6
        else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
