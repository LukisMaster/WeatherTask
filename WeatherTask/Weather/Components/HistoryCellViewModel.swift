//
//  HistoryCellViewModel.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import Foundation

protocol CellIdentifiable {
    var cellIdentifier: String { get }
}

protocol SectionRowPresentable {
    var rows: [CellIdentifiable] { get set }
}

final class HistoryCellViewModel : CellIdentifiable {
    var cellIdentifier: String {
        "HistoryCell"
    }
    
    let date: Date?
    let city: String
    let temp: String
    let unit: ForTemp
    
    init(model: WeatherInfoModel) {
        date = model.date
        city = model.city
        temp = model.temp
        unit = model.unit
    }
    
}

final class HistorySectionViewModel: SectionRowPresentable {
    var rows: [CellIdentifiable] = []
}
