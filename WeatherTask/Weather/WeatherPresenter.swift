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
        //without interactor
    }
    
    func didLocationButtonPressed() {
        interactor.fetchWeatherByLocation()
    }
    
    func didTemperatureStandardToggleSwitched(isEnable: Bool) {
        interactor.changeTemperatureStandard(value: isEnable ? TempStandard.celsius : TempStandard.fahrenheit)
    }
    
    func didSearchBarTextChanged(text: String) {
        interactor.fetchWeather(by: text)
    }
    
    func viewDidLoad() {
        interactor.fetchSearchHistory()
    }
    
}
// MARK: - WeatherInteractorOutputProtocol
extension WeatherPresenter: WeatherInteractorOutputProtocol {
    
    func temperatureStandardDidSet(with value: TempStandard, currentTemperatureCelsius: Int16) {
        view.updateInfoViewWith(city: "", tempCelsius: Int(currentTemperatureCelsius), celsiusIsOn: value == .celsius ? true : false)
    }
    
    func weatherIsFetched(weather: WeatherResponse , currentTemperatureStandard: TempStandard) {
        view.updateInfoViewWith(
            city: weather.name ?? "",
            tempCelsius: Int(weather.main?.temp ?? 0),
            celsiusIsOn: currentTemperatureStandard == .celsius ? true : false
        )
    }
    
    func fetchingFail(with error: Error) {
        print(error.localizedDescription)
    }
    
    func historyIsFetched(history: [Weather], tempStandard: TempStandard) {
        let rows = history.map { weather in
            let temp = tempStandard == .celsius ? weather.tempCelsius : (weather.tempCelsius).celsiusConvertToFahrenheit()
            return HistoryCellViewModel(
                date: weather.date,
                city: weather.cityName ?? "Empty city",
                temp: String(", \(temp)"),
                unit: tempStandard
            )
            
        }
        view.reloadHistory(for: HistorySectionViewModel(rows: rows))
    }

}


// MARK: - private MainPresenter

private extension WeatherPresenter {
    
}
