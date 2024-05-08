//
//  NetworkErrorViewController.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import UIKit
import SnapKit
import Combine

final class NetworkErrorViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "network.slash")
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "No Network, Please check your network"
        label.textColor = .red
        
        return label
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    private let viewModel: NetworkErrorViewModel
    
    init(viewModel: NetworkErrorViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

private extension NetworkErrorViewController {
    
    func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        [self.imageView, self.descriptionLabel].forEach { self.view.addSubview($0) }
        
        self.imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom)
            $0.centerX.equalTo(self.imageView)
        }
    }
    
    func bindViewModel() {
        let outputs = self.viewModel.bind(.init(viewDidLoad: self.viewDidLoadPublisher.eraseToAnyPublisher()))
        
        [outputs.events
            .sink(receiveValue: { _ in })
        ].forEach { self.cancellables.insert($0) }
        
    }
    
}


@available(iOS 17.0, *)
#Preview {
    NetworkErrorViewController(viewModel: NetworkErrorViewModel())
}
