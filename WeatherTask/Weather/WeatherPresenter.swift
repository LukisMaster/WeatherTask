//
//  WeatherPresenter.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import Foundation

struct WeatherHistoryData {
    
}

final class WeatherPresenter {
    weak var view: WeatherViewInputProtocol!
    var interactor: WeatherInteractorInputProtocol!
}


// MARK: - WeatherViewOutputProtocol
extension WeatherPresenter: WeatherViewOutputProtocol {
    func didHistoryCellDeleted(at index: Int) {
        interactor.removeHistoryItem(at: index)
    }
    
    func didTapCell(with cellViewModel: HistoryCellViewModel) {
        // for future optional tasks
    }
    
    func didLocationButtonPressed() {
        interactor.fetchWeatherByLocation()
    }
    
    func didTemperatureStandardToggleSwitched(isEnable: Bool) {
        interactor.changeTemperatureStandard(value: isEnable ? TemperatureUnits.celsius : TemperatureUnits.fahrenheit)
        interactor.fetchSearchHistory()
    }
    
    func didSearchBarSend(text: String) {
        interactor.fetchWeather(by: text)
    }
    
    func viewDidLoad() {
        interactor.fetchSearchHistory()
        interactor.fetchStartInfoViewValues()
    }
    
}
// MARK: - WeatherInteractorOutputProtocol
extension WeatherPresenter: WeatherInteractorOutputProtocol {
    func newWeatherDidFetched(temp: Double, city: String, date: Date, units: TemperatureUnits) {
        let cellViewModel = HistoryCellViewModel(date: date, city: city, temp: String(Int(temp)), unit: units)
        view.insertRowInHistoryTable(cellViewModel: cellViewModel)
        view.updateInfoViewWith(
            city: city,
            tempCelsius: Int(temp),
            celsiusIsOn: units == .celsius ? true : false
        )
        
    }
    
    
    func startInfoViewValuesDidFetched(units: TemperatureUnits, city: String, temperatureCelsius: Int) {
        view.updateInfoViewWith(
            city: city,
            tempCelsius: temperatureCelsius,
            celsiusIsOn: units == .celsius ? true : false
            )
    }
    
    func temperatureStandardDidSet(with value: TemperatureUnits, currentTemperatureCelsius: Int) {
        view.updateInfoViewWith(city: "", tempCelsius: currentTemperatureCelsius, celsiusIsOn: value == .celsius ? true : false)
    }
    
    func fetchingFail(with error: Error) {
        print(error.localizedDescription)   // здесь можно придумать вывод алертов на экран, если надо
    }
    
    func historyIsFetched(history: [Weather], tempStandard: TemperatureUnits) {
        let rows = history.map { weather in
            let temp = tempStandard == .celsius ? weather.tempCelsius : weather.tempCelsius.celsiusConvertToFahrenheit()
            return HistoryCellViewModel(
                date: weather.date,
                city: weather.cityName ?? "Empty city",
                temp: String(temp),
                unit: tempStandard
            )
            
        }
        view.reloadHistory(for: HistorySectionViewModel(rows: rows))
    }

}


// MARK: - private MainPresenter

private extension WeatherPresenter {
    
}
