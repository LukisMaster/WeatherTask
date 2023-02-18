//
//  MainPresenter.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

protocol MainPresenterProtocol: PresenterProtocol {
    
}



final class MainPresenter {
    private weak var view: MainViewControllerProtocol?
    
    init(view: MainViewControllerProtocol?) {
        self.view = view
    }
}


// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
    }
}


// MARK: - private MainPresenter

private extension MainPresenter {
    
}
