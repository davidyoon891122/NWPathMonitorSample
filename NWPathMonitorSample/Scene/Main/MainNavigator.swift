//
//  MainNavigator.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit

protocol MainNavigatorProtocol {
    
    func toView()
    func toPresentView()
    func toErrorView()
    
}

struct MainNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

extension MainNavigator: MainNavigatorProtocol {
    
    func toView() {
        let vm = MainViewModel(navigator: self)
        let vc = MainViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toPresentView() {
        let navigator = PresentNavigator(navigationController: self.navigationController)
        navigator.toPresent()
    }
    
    func toErrorView() {
        let navigator = NetworkErrorNavigator(navigationController: self.navigationController)
        navigator.toNWErrorView()
    }
    
}
