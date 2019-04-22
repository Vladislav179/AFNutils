//
//  Hashed+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension Collection {
    var pairs: [SubSequence] {
        var start = startIndex
        return (0...count/2).map { _ in
            let end = index(start, offsetBy: 2, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}

