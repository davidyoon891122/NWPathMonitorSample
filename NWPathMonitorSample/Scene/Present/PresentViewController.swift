//
//  PresentViewController.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit
import Combine

final class PresentViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    
    private let viewModel: PresentViewModel
    
    init(viewModel: PresentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindViewModel()
        self.viewDidLoadPublisher.send()
    }
    
}

private extension PresentViewController {
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(viewDidLoad: self.viewDidLoadPublisher.eraseToAnyPublisher()))
        
        [outputs.events
            .sink(receiveValue: { _ in })].forEach { self.cancellables.insert($0) }
        
    }
    
}
