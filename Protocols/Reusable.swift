//
//  Reusable.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
