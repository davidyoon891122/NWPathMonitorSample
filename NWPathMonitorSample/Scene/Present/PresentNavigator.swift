//
//  PresentNavigator.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit

protocol PresentNavigatorProtocol {
    
    func toPresent()
    func toErrorView()
    
}

struct PresentNavigator {
    
    private weak var presentingController: UIViewController?
    private let navigationController: UINavigationController
    
    init(presentingController: UIViewController? = nil) {
        self.presentingController = presentingController
        self.navigationController = UINavigationController()
    }
    
}

extension PresentNavigator: PresentNavigatorProtocol {
    
    func toPresent() {
        let vm = PresentViewModel(navigator: self)
        let vc = PresentViewController(viewModel: vm)
        
        self.navigationController.pushViewController(vc, animated: false)
    
        self.presentingController?.present(self.navigationController, animated: true)
        
    }
    
    func toErrorView() {
        let navigator = NetworkErrorNavigator(navigationController: self.navigationController)
        navigator.toNWErrorView()
    }
    
}
