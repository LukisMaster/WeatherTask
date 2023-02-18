//
//  MainBuilder.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit


struct MainBuilder {
    static func create() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view)
        
        view.presenter = presenter
        
        return view
    }
}
