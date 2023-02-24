//
//  WeatherInteractor.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 20.02.2023.
//

import Foundation
import CoreLocation


protocol WeatherInteractorInputProtocol: AnyObject {
    func fetchWeatherByLocation()
    func fetchWeather(by city: String)
    func fetchSearchHistory()
    func changeTemperatureStandard(value: TempStandard)
}

protocol WeatherInteractorOutputProtocol: AnyObject {
    func weatherIsFetched(weather: WeatherResponse, currentTemperatureStandard: TempStandard)
    func fetchingFail(with error: Error)
    func historyIsFetched(history: [Weather])
    func temperatureStandardDidSet(with value: TempStandard, currentTemperatureCelsius: Int16)
}

final class WeatherInteractor {
    private let networkService: NetworkFetchWeather = NetworkManager.shared
    private let dataService = CoreDataManager.shared
    private let locationService = LocationManager.shared
    
    private var temperatureStandard : TempStandard = .celsius
    private var currentTemperatureCelsius : Int16 = 0
    
    weak var presenter: WeatherInteractorOutputProtocol!
}

// MARK: - WeatherInteractorInputProtocol

extension WeatherInteractor: WeatherInteractorInputProtocol {

    func fetchWeatherByLocation() {
        guard let coordinate = LocationManager.shared.location?.coordinate else {
            fatalError("In WeatherInteractor. Can't get location coordinates") // тут можно заменить на обработчик ошибки
        }
        print(coordinate)
        networkService.fetchWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
            case .success(let weatherResponse):
                print(weatherResponse)
                print(Int16(weatherResponse.main?.temp ?? 0.0))

                self?.currentTemperatureCelsius = Int16(weatherResponse.main?.temp ?? 0.0)
                self?.presenter.weatherIsFetched(
                    weather: weatherResponse,
                    currentTemperatureStandard: self?.temperatureStandard ?? .celsius
                )
            }
        }
    }
    
    
    func fetchWeather(by city: String) {
         networkService.fetchCoordinatesData(city: city) { [weak self] result in
             switch result {
             case .failure(let error):
                 self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
             case .success(let cityResponse):
                 guard let lat = cityResponse.lat, let lon = cityResponse.lon else {
                     fatalError("In WeatherInteractor. Not corrected city latitude or longitude ") // тут можно заменить на обработчик ошибки
                 }
                 self?.networkService.fetchWeatherData(latitude: lat, longitude: lon) { result in
                     switch result {
                     case .failure(let error):
                         self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
                     case .success(let weatherResponse):
                         print(weatherResponse)
                         self?.presenter.weatherIsFetched(
                             weather: weatherResponse,
                             currentTemperatureStandard: self?.temperatureStandard ?? .celsius
                         )
                     }
                 }
             }
         }
     }
    
    func fetchSearchHistory() {
        let history = dataService.fetchWeatherData()
        presenter.historyIsFetched(history: history)
    }
    
    func changeTemperatureStandard(value: TempStandard) {
        temperatureStandard = value
        presenter.temperatureStandardDidSet(with: temperatureStandard, currentTemperatureCelsius: currentTemperatureCelsius)
    }
}


// MARK: - Private

private extension WeatherInteractor {
    func handleError(_ error: Error) {
        // Обработка ошибки
    }
}
