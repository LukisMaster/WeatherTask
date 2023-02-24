//
//  WeatherViewController.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit
import Foundation



protocol WeatherViewInputProtocol: AnyObject {
    // from presenter to view
    func reloadHistory(for: SectionRowPresentable)
}

protocol WeatherViewOutputProtocol: PresenterProtocol {
    // from view to presenter
    func didTapCell(with cellViewModel: HistoryCellViewModel)
    func didLocationButtonPressed()
    func didTemperatureStandardToggleSwitched(isEnable: Bool)
    func didSearchBarButtonPressed(text: String)
}

final class WeatherViewController: ViewController {
    
    var presenter: WeatherViewOutputProtocol!
    private var section: SectionRowPresentable = HistorySectionViewModel()
    private var timer: Timer?
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var historyTable: UITableView = {
        let table = UITableView()
        table.subscribe(self)
        table.register(HistoryTableViewCell.self, forCellReuseIdentifier: WeatherConstants.cellReuseIdentifier)
        table.rowHeight = WeatherConstants.rowHeight
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        setupUI()
    }
    
    
}

// MARK: - WeatherViewInputProtocol
extension WeatherViewController: WeatherViewInputProtocol {
    func reloadHistory(for: SectionRowPresentable) {
        //
    }
}


// MARK: - private WeatherViewController
private extension WeatherViewController {
    
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
        searchController.searchBar.placeholder = "Сity name"
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = section.rows[safe: indexPath.item] else {
            return UITableViewCell()
        }
        let cell = historyTable.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath) as! HistoryTableViewCell
        cell.viewModel = viewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cellViewModel = section.rows[indexPath.row] as? HistoryCellViewModel else { return }
        presenter.didTapCell(with: cellViewModel)
    }
    
}


// MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            print(searchText) // отправять все в презентер через делегат
                              // в презентере вся логика с нетворк сервисом
        })
    }
}

// MARK: - InfoViewDelegate
extension WeatherViewController: InfoViewDelegate {
    func updateData(viewModel: InfoViewModel) {
        //
    }
    
    func switchValueChanged(temperatureStandardSwitchIsOn: Bool) {
        presenter.didTemperatureStandardToggleSwitched(isEnable: temperatureStandardSwitchIsOn)
    }
}


// MARK: - private enum
private extension WeatherViewController {
    enum WeatherConstants {
        static let rowHeight: CGFloat = 80
        static let cellReuseIdentifier: String = "HistoryCell"
    }
}
