//
//  PresentNavigator.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit

protocol PresentNavigatorProtocol {
    
    func toPresent()
    
}

struct PresentNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

extension PresentNavigator: PresentNavigatorProtocol {
    
    func toPresent() {
        let vm = PresentViewModel()
        let vc = PresentViewController(viewModel: vm)
        self.navigationController?.present(vc, animated: true)
    }
    
}
