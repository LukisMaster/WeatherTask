//
//  WeatherResponse.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 20.02.2023.
//


// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let main: Main?
    let id: Int?
    let name: String?
}


// MARK: - Main
struct Main: Decodable {
    let temp, tempMin, tempMax: Double?
}
