//
//  UIView+Extensions.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit

extension UIView {
    func subviews(_ object: UIView...) {
        object.forEach {
            addSubview($0)
        }
    }
}
