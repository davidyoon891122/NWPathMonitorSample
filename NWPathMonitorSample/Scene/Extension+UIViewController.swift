//
//  Extension+UIViewController.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import UIKit

extension UIViewController {
    
    private struct ToastKeys {
        static var toastView  = "com.toast-swift.toastView"
    }
    
    private var toastView: ToastView? {
        if let toastView = objc_getAssociatedObject(self, &ToastKeys.toastView) as? ToastView {
            return toastView
        } else {
            let toastView = ToastView()
            objc_setAssociatedObject(self, &ToastKeys.toastView, toastView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return toastView
        }
    }
    
    
    func openToast() {
        guard let toastView = toastView else { return }
        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16.0)
            $0.trailing.equalToSuperview().offset(-16.0)
            $0.height.equalTo(50.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
        }
        toastView.alpha = 0.0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            toastView.alpha = 1.0
        }
        
    }
    
    func closeToast() {
        guard let toastView = toastView else { return }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toastView.alpha = 0.0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
        
    }
    
    
    
}
