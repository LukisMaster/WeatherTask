//
//  Array+Extensions.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

extension Array {
    subscript (safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }
}
