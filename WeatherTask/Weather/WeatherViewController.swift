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
    func reloadHistory(for section: SectionRowPresentable)
    func updateInfoViewWith(city: String, tempCelsius: Int, celsiusIsOn: Bool)
    func insertRowInHistoryTable(cellViewModel: HistoryCellViewModel)
}

protocol WeatherViewOutputProtocol: PresenterProtocol {
    // from view to presenter
    func didTapCell(with cellViewModel: HistoryCellViewModel) // to future optional tasks
    func didLocationButtonPressed()
    func didTemperatureStandardToggleSwitched(isEnable: Bool)
    func didSearchBarSend(text: String)
    func didHistoryCellDeleted(at index: Int)
}

final class WeatherViewController: ViewController {
    
    var presenter: WeatherViewOutputProtocol!
    private var section: SectionRowPresentable?
    
    private lazy var infoView: InfoView = {
        let view = InfoView()
        view.delegate = self
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
    func insertRowInHistoryTable(cellViewModel: HistoryCellViewModel) {
        self.section?.rows.insert(cellViewModel, at: 0)
        DispatchQueue.main.async {  [weak self] in
            self?.historyTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func updateInfoViewWith(city: String, tempCelsius: Int, celsiusIsOn: Bool) {
        infoView.update(from: InfoViewModel(city: city, tempCelsius: tempCelsius, celsiusIsOn: celsiusIsOn))
    }
    
    func reloadHistory(for section: SectionRowPresentable) {
        self.section = section
        DispatchQueue.main.async {  [weak self] in
            self?.historyTable.reloadData()
        }
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
        geoButton.addTarget(self, action: #selector(didTapGeoButton), for: .touchUpInside)
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

// MARK: - @objc private WeatherViewController

@objc
private extension WeatherViewController {
    func didTapGeoButton() {
        presenter.didLocationButtonPressed()
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.section?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = section?.rows[safe: indexPath.item] else {
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
        guard let cellViewModel = section?.rows[indexPath.row] as? HistoryCellViewModel else { return }
        presenter.didTapCell(with: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            section?.rows.remove(at: indexPath.row)
            presenter.didHistoryCellDeleted(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}


// MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        presenter.didSearchBarSend(text: searchText)
    }
}

// MARK: - InfoViewDelegate
extension WeatherViewController: InfoViewDelegate {
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
