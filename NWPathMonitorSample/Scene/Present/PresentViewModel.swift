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
        
        let events = Publishers.MergeMany(
            inputs.viewDidLoad
                .flatMap { _ -> AnyPublisher<Void, Never> in
                    networkManager.networkStatusPublisher
                        .receive(on: DispatchQueue.main)
                        .handleEvents(receiveOutput: { status in
                            switch status {
                            case .satisfied(let type):
                                print("satisfied type: \(type)")
                            case .unsatisfied:
                                navigator.toErrorView()
                            case .requiresConnection:
                                navigator.toErrorView()
                            }
                        })
                        .map { _ in }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        return .init(events: events)
    }
    
}
