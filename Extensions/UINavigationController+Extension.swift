//
//  UINavigationController+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension UINavigationController {
    func backToViewController(vc: Any) {
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


extension UINavigationController {
    public func hasViewController(ofKind kind: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: {$0.isKind(of: kind)})
    }
}
