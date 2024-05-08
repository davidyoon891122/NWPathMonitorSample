//
//  NetworkErrorViewModel.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import Foundation
import Combine

struct NetworkErrorViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let events: AnyPublisher<Void, Never>
    }
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
}

extension NetworkErrorViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad.flatMap { _ -> AnyPublisher<Void, Never> in
                networkManager.networkStatusPublisher.handleEvents(receiveOutput: { status in
                    print(status)
                })
                .map { _ in }
                .eraseToAnyPublisher()
            }
            
        )
            .eraseToAnyPublisher()
        
        return .init(events: events)
    }
    
}
