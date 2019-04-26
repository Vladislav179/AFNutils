//
//  UIApplication+Extensions.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension UIApplication {

    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    class func presentedViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return presentedViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return presentedViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return presentedViewController(controller: presented)
        }
        return controller
    }

    class func alert(title: String = String(), message mess: String, controller: UIViewController? = UIApplication.presentedViewController()) {
        let alertController = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let selfController = controller else { return }
        selfController.present(alertController, animated: true)
    }
}

