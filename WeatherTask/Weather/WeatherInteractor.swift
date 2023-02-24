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
    func fetchCoordinates(by city: String)
    func fetchSearchHistory()
}

protocol WeatherInteractorOutputProtocol: AnyObject {
    func coordinatesAreFetched(coordinates: CityResponse)
    func weatherIsFetched(weather: WeatherResponse)
    func fetchingFail(with error: Error)
    func historyIsFetched(history: [Weather])
    
//    func receiveWeatherData(weatherData: WeatherHistoryData)
//    func presentWeather(response: WeatherResponse)
//    func presentError(_ error: Error)
}

final class WeatherInteractor {
    private let networkService: NetworkFetchWeather = NetworkManager.shared
    private let dataService = CoreDataManager.shared
    private let locationService = LocationManager.shared
    
    weak var presenter: WeatherInteractorOutputProtocol!
}

// MARK: - WeatherInteractorInputProtocol

extension WeatherInteractor: WeatherInteractorInputProtocol {
    func fetchWeatherByLocation() {
        guard let coordinate = LocationManager.shared.location?.coordinate else {return}
        networkService.fetchWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
            case .success(let weatherResponse):
                self?.presenter.weatherIsFetched(weather: weatherResponse)
            }
        }
    }
    
    
    func fetchCoordinates(by city: String) {
         networkService.fetchCoordinatesData(city: city) { [weak self] result in
             switch result {
             case .failure(let error):
                 self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
             case .success(let cityResponse):
                 guard let lat = cityResponse.lat, let lon = cityResponse.lon else {
                     fatalError() // тут можно заменить на обработчик ошибки
                 }
                 self?.networkService.fetchWeatherData(latitude: lat, longitude: lon) { result in
                     switch result {
                     case .failure(let error):
                         self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
                     case .success(let weatherResponse):
                         self?.presenter.weatherIsFetched(weather: weatherResponse)
                     }
                 }
                 self?.presenter.coordinatesAreFetched(coordinates: cityResponse)
             }
         }
     }
    
    func fetchSearchHistory() {
        let history = dataService.fetchWeatherData()
        presenter.historyIsFetched(history: history)
    }
}


// MARK: - Private

private extension WeatherInteractor {
    func handleError(_ error: Error) {
        // Обработка ошибки
    }
}
