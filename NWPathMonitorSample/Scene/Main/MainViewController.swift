//
//  MainViewController.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class MainViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    
    private let viewModel: MainViewModel
    
    private lazy var presentButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.setTitle("Present", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray
        
        return button
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.bindViewModel()
        self.viewDidLoadPublisher.send()
    }

}

private extension MainViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        [self.presentButton].forEach { self.view.addSubview($0) }
        
        self.presentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
            $0.height.equalTo(50.0)
        }
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(
            viewDidLoad: self.viewDidLoadPublisher.eraseToAnyPublisher(),
            buttonTapped: self.presentButton.tapPublisher
        ))
        
        [outputs.events
            .sink(receiveValue: { _ in }),
         outputs.toast.sink(receiveValue: { [weak self] status in
            switch status {
            case .satisfied(let networkType):
                self?.closeToast()
            case .unsatisfied:
                self?.openToast()
            case .requiresConnection:
                self?.openToast()
            }
        })
        ].forEach { self.cancellables.insert($0) }
        
    }
    
}

@available(iOS 17.0, *)
#Preview {
    MainViewController(viewModel: MainViewModel(navigator: MainNavigator(navigationController: nil)))
}
