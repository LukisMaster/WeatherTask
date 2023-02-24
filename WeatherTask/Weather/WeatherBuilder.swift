//
//  WeatherBuilder.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

//import UIKit


final class WeatherBuilder {
    static func create() -> ViewController {
        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter()
        let view = WeatherViewController()
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        return view
    }
}
