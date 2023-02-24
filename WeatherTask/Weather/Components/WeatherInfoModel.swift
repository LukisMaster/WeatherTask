//
//  WeatherInfoModel.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 23.02.2023.
//

import Foundation

struct WeatherInfoModel {
    let date: Date?
    let city: String
    let temp: String
    let unit: TempStandard
}

enum TempStandard {
    case celsius
    case fahrenheit
}

enum BackgroundHexColor: String {
    case lightBlue = "#5ac8fa"
    case lightOrange = "#FFD580"
    case lightRed = "#FF6666"
}
