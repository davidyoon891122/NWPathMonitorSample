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
        let toast: AnyPublisher<NetworkStatus, Never>
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
        let navigator = navigator
        
        let toastPublisher = PassthroughSubject<NetworkStatus, Never>()
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad.flatMap { _ -> AnyPublisher<Void, Never> in
                self.networkManager.networkStatusPublisher
                    .receive(on: DispatchQueue.main)
                    .handleEvents(receiveOutput: { status in
                        toastPublisher.send(status)
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
            
            
        
        
        return .init(events: events, toast: toastPublisher.eraseToAnyPublisher())
    }
    
}
