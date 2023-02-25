//
//  Int16+Extensions.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 25.02.2023.
//

extension Int16 {
    func celsiusConvertToFahrenheit() -> Int16 {
       (self * 9 / 5) + 32
    }
}
