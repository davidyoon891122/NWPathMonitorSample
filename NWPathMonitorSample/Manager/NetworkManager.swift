//
//  NetworkManager.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import Foundation
import Network
import Combine

enum NetworkType {
    
    case wifi
    case wwan
    
}

enum NetworkStatus {
    
    case satisfied(NetworkType)
    case unsatisfied
    case requiresConnection
    
}

protocol NetworkManagerProtocol {
    
    var networkStatusPublisher: PassthroughSubject<NetworkStatus, Never> { get }
    func startMonitor()
    func stopMonitor()
    
}

final class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()

    var networkStatusPublisher: PassthroughSubject<NetworkStatus, Never> = .init()
    private let nwPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    
    private init() {
        self.startMonitor()
    }
    
}

extension NetworkManager: NetworkManagerProtocol {
    
    func startMonitor() {
        self.nwPathMonitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .satisfied:
                if path.usesInterfaceType(.wifi) {
                    self?.networkStatusPublisher.send(.satisfied(.wifi))
                } else {
                    self?.networkStatusPublisher.send(.satisfied(.wwan))
                }
            case .unsatisfied:
                self?.networkStatusPublisher.send(.unsatisfied)
            case .requiresConnection:
                self?.networkStatusPublisher.send(.requiresConnection)
            @unknown default:
                self?.networkStatusPublisher.send(.unsatisfied)
            }
        }
        self.nwPathMonitor.start(queue: queue)
    }
    
    func stopMonitor() {
        self.nwPathMonitor.cancel()
    }
    
}
