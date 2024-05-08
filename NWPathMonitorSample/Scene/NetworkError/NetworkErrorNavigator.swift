//
//  NetworkErrorNavigator.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import UIKit

protocol NetworkErrorNavigatorProtocol {
    
    func toNWErrorView()
    
}

struct NetworkErrorNavigator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
}

extension NetworkErrorNavigator: NetworkErrorNavigatorProtocol {
    
    func toNWErrorView() {
        let vm = NetworkErrorViewModel()
        let vc = NetworkErrorViewController(viewModel: vm)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
