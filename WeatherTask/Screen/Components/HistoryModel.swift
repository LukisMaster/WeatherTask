//
//  HistoryModel.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import Foundation


struct HistoryModel {
    let date: Date?
    let city: String
    let temp: String
    let unit: ForTemp
}

enum ForTemp {
    case celcius
    case fahrenheit
}
