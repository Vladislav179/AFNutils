//
//  UITableView+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension UITableView {
    final func register<T: UITableViewCell>(_ cellType: T.Type) where T:  NibLoadable {
        register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }

    final func register<T: UITableViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,
                                                       with cellType: T.Type = T.self) -> T where T:Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
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

extension UITableView {

    func scrollToBottom(){

        if (self.indexPathsForVisibleRows?.count ?? 0) < 3 {
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: max(self.numberOfRows(inSection: max(self.numberOfSections - 1, 0)) - 1, 0), section: max(self.numberOfSections - 1, 0))
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}


extension UITableViewCell {

    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            return nil
        }

        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}


extension Sequence {
    func groupSort(ascending: Bool = true, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
        var categories: [[Iterator.Element]] = []
        for element in self {
            let key = dateKey(element)
            guard let dayIndex = categories.firstIndex(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
                guard let nextIndex = categories.firstIndex(where: { $0.contains(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                    categories.append([element])
                    continue
                }
                categories.insert([element], at: nextIndex)
                continue
            }

            guard let nextIndex = categories[dayIndex].firstIndex(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) else {
                categories[dayIndex].append(element)
                continue
            }
            categories[dayIndex].insert(element, at: nextIndex)
        }
        return categories
    }
}
