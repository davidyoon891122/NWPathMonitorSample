//
//  Extension+SceneDelegate.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/8/24.
//

import UIKit

extension UIApplication {
    
    static var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
    }
    
}
