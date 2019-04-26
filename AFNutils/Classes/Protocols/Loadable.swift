//
//  Loadable.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

protocol Loadable: class {
    //MARK: --Load UIViewController or UIView from Nib
    static var storyboardName: String { get }
}

extension Loadable where Self: UIViewController {

    static func loadController() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
        return controller
    }
}

protocol NibLoadable: class {
    //MARK: --Load UIViewController or UIView from Nib
    static var nib: UINib { get }
}

extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension NibLoadable where Self: UIView {
    var contentHeight: CGFloat {
        var h: CGFloat = 0.0
        self.subviews.forEach { (view) in h = h + view.frame.size.height }
        return h
    }
}

extension NibLoadable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension NibLoadable where Self: UIView {
    static func load() -> Self {
        if let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? Self { return view }
        fatalError("Could not load view with type " + String(describing: self))
    }
}

extension UIViewController {
    static var storyboardID: String {
        return String(describing: self)
    }
}
