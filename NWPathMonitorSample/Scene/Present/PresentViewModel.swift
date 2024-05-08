//
//  PresentViewModel.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import Foundation
import Combine

struct PresentViewModel {
    
    struct Inputs {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Outputs {
        let events: AnyPublisher<Void, Never>
        let toast: AnyPublisher<NetworkStatus, Never>
    }
    
    private let navigator: PresentNavigatorProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(
        navigator: PresentNavigatorProtocol,
        networkManager: NetworkManagerProtocol = NetworkManager.shared
    ) {
        self.navigator = navigator
        self.networkManager = networkManager
    }
    
}

extension PresentViewModel {
    
    func bind(_ inputs: Inputs) -> Outputs {
        let navigator = navigator
        
        let toastPublisher = PassthroughSubject<NetworkStatus, Never>()
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad
                .flatMap { _ -> AnyPublisher<Void, Never> in
                    networkManager.networkStatusPublisher
                        .receive(on: DispatchQueue.main)
                        .handleEvents(receiveOutput: { status in
                            toastPublisher.send(status)
                        })
                        .map { _ in }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(events: events, toast: toastPublisher.eraseToAnyPublisher())
    }
    
}
