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
    case cellular
    case wiredEthernet
    case loopback
    case other
    
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
    private let queue = DispatchQueue.global() // 이벤트를 백그라운드에서 처리하기 위해 global queue로 선언
    
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
                } else if path.usesInterfaceType(.cellular) {
                    self?.networkStatusPublisher.send(.satisfied(.cellular))
                } else if path.usesInterfaceType(.wiredEthernet) {
                    self?.networkStatusPublisher.send(.satisfied(.wiredEthernet))
                } else if path.usesInterfaceType(.loopback) {
                    self?.networkStatusPublisher.send(.satisfied(.loopback))
                } else {
                    self?.networkStatusPublisher.send(.satisfied(.other))
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
