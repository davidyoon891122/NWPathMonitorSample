//
//  ToastView.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import UIKit
import SnapKit

final class ToastView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Toast"
        title.textColor = .red
        
        return title
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        
        view.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ToastView {
    
    func setupViews() {
        self.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    ToastView()
}

