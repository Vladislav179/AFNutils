//
//  UICollectionView+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension UICollectionView {
    final func register<T: UICollectionViewCell>(_ cellType: T.Type) where T:  NibLoadable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    final func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath,
                                                            cellType: T.Type = T.self) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }

        return cell
    }

    func reload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}


extension UICollectionView {
    func indexPathForView(view: AnyObject) -> IndexPath? {
        guard let view = view as? UIView else { return nil }
        let senderIndexPath = self.convert(CGPoint.zero, from: view)
        return self.indexPathForItem(at: CGPoint(x: senderIndexPath.x, y: senderIndexPath.y.abs()))
    }
}

extension UIResponder {
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}

extension UICollectionViewCell {
    var indexPath: IndexPath? {
        return next(UICollectionView.self)?.indexPath(for: self)
    }
}
