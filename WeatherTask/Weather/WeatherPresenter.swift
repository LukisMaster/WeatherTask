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
    func didTapCell(with cellViewModel: HistoryCellViewModel) {
        //without interactor
    }
    
    func didLocationButtonPressed() {
        interactor.fetchWeatherByLocation()
    }
    
    func didTemperatureStandardToggleSwitched(isEnable: Bool) {
        //without interactor
    }
    
    func didSearchBarButtonPressed(text: String) {
        interactor.fetchCoordinates(by: text)
    }
    
    func viewDidLoad() {
        interactor.fetchSearchHistory()
    }
    
//    func viewDidLoad() {
////        interactor.fetchSearchHistory()
//    }
    
//    func getCurrentWeather(for cityName: String) {
//        interactor.fetchCoordinates(by: cityName) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let weatherResponse):
//                self.presentWeather(response: weatherResponse)
//            case .failure(let error):
//                self.presentError(error)
//            }
//        }
//    }
}
// MARK: - WeatherInteractorOutputProtocol
extension WeatherPresenter: WeatherInteractorOutputProtocol {
    func receiveWeatherData(weatherData: WeatherHistoryData) {
        <#code#>
    }
    
    func presentWeather(response: WeatherResponse) {
        <#code#>
    }
    
    func presentError(_ error: Error) {
        <#code#>
    }
    
    
    func weatherHistoryDidReceive(weatherHistory: [Weather]) {
        let section = HistorySectionViewModel()
        weatherHistory.forEach { weather in
            section.rows.append(HistoryCellViewModel(model: WeatherInfoModel(
                date: weather.date,
                city: weather.cityName ?? "No city data",
                temp: String(weather.tempCelsius),
                unit: .celcius
            )))
        }
        view.reloadHistory(for: section)
    }
}


// MARK: - private MainPresenter

private extension WeatherPresenter {
    
}
