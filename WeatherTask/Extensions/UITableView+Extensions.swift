//
//  UITableView+Extensions.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit


extension UITableView {
    func subscribe(_ object: (UITableViewDelegate
                              & UITableViewDataSource)) {
        delegate = object
        dataSource = object
    }
    
}
