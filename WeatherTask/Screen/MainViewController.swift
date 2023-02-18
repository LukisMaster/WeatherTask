//
//  MainViewController.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit
import Foundation

protocol MainViewControllerProtocol: AnyObject {
    
}

final class MainViewController: ViewController {
    
    var presenter: MainPresenterProtocol?
    private var timer: Timer?
    private var historyModel = [
        HistoryModel(date: nil, city: "SPB", temp: "0", unit: .celcius),
        HistoryModel(date: nil, city: "Irkutsk", temp: "-30", unit: .celcius)
    ]

    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var historyTable: UITableView = {
        let table = UITableView()
        table.subscribe(self)
        table.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        table.rowHeight = Constants.rowHeight
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        setupUI()
    }
    
    
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
}


// MARK: - private MainViewController

private extension MainViewController {
    
    func setupUI() {
        view.subviews(infoView, historyTable)
        setupNavigationItem()
        
        NSLayoutConstraint.activate([
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor,constant: 150),
            infoView.heightAnchor.constraint(equalToConstant: view.bounds.height / 5),
            infoView.widthAnchor.constraint(equalToConstant: view.bounds.width),

            historyTable.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            historyTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyTable.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
    }
    
    func setupNavigationItem() {
        setupTitle()
        setupGeoRightButton()
        setupSearchBar()
    }
    
    func setupTitle() {
        navigationItem.title = "Weather"
    }
    
    func setupGeoRightButton() {
        let geoButton = UIButton()
        let geoImage = UIImage(named: "geo")
        geoButton.setImage(geoImage, for: .normal)
        let geoButtonItem = UIBarButtonItem(customView: geoButton)
        navigationItem.rightBarButtonItem = geoButtonItem
    }
    
    func setupSearchBar() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Sity name"
        searchController.searchBar.delegate = self
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        guard let model = historyModel[safe: indexPath.item] else {
            return UITableViewCell()
        }
        print(model)
        cell.configure(model: model)
        return cell
    }
    
    
}


// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            print(searchText) // отправять все в презентер через делегат
                              // в презентере вся логика с нетворк сервисом
        })
    }
}


// MARK: - private enum

private extension MainViewController {
    enum Constants {
        static let rowHeight: CGFloat = 80
    }
}
