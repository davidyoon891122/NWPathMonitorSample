//
//  MainViewModel.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import Foundation
import Combine

struct MainViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
        let buttonTapped: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let events: AnyPublisher<Void, Never>
    }
    
    private let navigator: MainNavigatorProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(
        navigator: MainNavigatorProtocol,
        networkManager: NetworkManagerProtocol = NetworkManager.shared
    ) {
        self.navigator = navigator
        self.networkManager = networkManager
    }
    
}

extension MainViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad.flatMap { _ -> AnyPublisher<Void, Never> in
                self.networkManager.networkStatusPublisher
                    .handleEvents(receiveOutput: { status in
                        print("status on ViewModel \(status)")
                    })
                    .map { _ in }
                    .eraseToAnyPublisher()
            }
                .eraseToAnyPublisher(),
            inputs.buttonTapped
                .handleEvents(receiveOutput: { _ in
                    print("Present newView")
                    navigator.toPresentView()
                })
                .map { _ in }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
            
            
        
        
        return .init(events: events)
    }
    
}
