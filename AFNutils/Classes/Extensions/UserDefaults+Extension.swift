//
//  UserDefaults+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

public extension UserDefaults {

    // MARK: - subscripts
    subscript(key: DefaultsKey<Bool>) -> Bool {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<Int>) -> Int {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<Float>) -> Float {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<Double>) -> Double {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript<T>(key: DefaultsKey<T>) -> T? {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    // MARK: Codeable workarounds
    subscript(key: DefaultsKey<String>) -> String? {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<Data>) -> Data? {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<Date>) -> Date? {
        get { return value(key) }
        set { self[key.stringValue] = newValue }
    }


    // MARK: URL workarounds
    subscript(key: DefaultsKey<URL>) -> URL? {
        get { return url(forKey: key.stringValue) }
        set { self[key.stringValue] = newValue }
    }

    subscript(key: DefaultsKey<[URL]>) -> [URL]? {
        get {
            guard let urls = array(forKey: key.stringValue) as? [String] else { return nil }
            return urls.map { URL(string: $0) ?? NSURL() as URL }
        }
        set {
            self[key.stringValue] = newValue
        }
    }

    subscript(key: DefaultsKey<[String : URL]>) -> [String : URL]? {
        get {
            guard let urls = dictionary(forKey: key.stringValue) as? [String : String] else { return nil }
            var urlDict = [String:URL]()
            for url in urls {
                urlDict[url.key] = URL(string: url.value) ?? NSURL() as URL
            }
            return urlDict
        }
        set {
            self[key.stringValue] = newValue
        }
    }

    subscript<T: Codable>(key: DefaultsKey<T>) -> T? {
        get {
            guard let data = data(forKey: key.stringValue) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            self[key.stringValue] = data
        }
    }

    // MARK: - String subscript
    subscript(key: String) -> Any? {
        set(value) {
            guard let value = value else {
                removeObject(forKey: key)
                return
            }
            switch value {
            case
            is String,
            is NSNumber,
            is Data,
            is Date,
            // Array
            is [String],
            is [NSNumber],
            is [Data],
            is [Date],
            // Dictionary
            is [String: String],
            is [String: NSNumber],
            is [String: Data],
            is [String: Date]:
                set(value, forKey: key)
            case is URL:
                set(value as? URL, forKey: key)
            case is [URL]:
                guard let urls = value as? [URL] else {
                    assertionFailure("Invalid URL array")
                    return
                }
                self[key] = urls.map { $0.absoluteString }
            case is [String: URL]:
                guard let urls = value as? [String: URL] else {
                    assertionFailure("Invalid URL dictionary")
                    return
                }
                var urlDict = [String:String]()
                for url in urls {
                    urlDict[url.key] = url.value.absoluteString
                }
                self[key] = urlDict
            default:
                assertionFailure("Invalid value type")
            }
        }
        get {
            return object(forKey: key)
        }
    }

    // MARK: - Getting values associated with the specified DefaultsKey

    private func value(_ key: DefaultsKey<Bool>) -> Bool {
        return bool(forKey: key.stringValue)
    }

    private func value(_ key: DefaultsKey<Int>) -> Int {
        return integer(forKey: key.stringValue)
    }

    private func value(_ key: DefaultsKey<Float>) -> Float {
        return float(forKey: key.stringValue)
    }

    private func value(_ key: DefaultsKey<Double>) -> Double {
        return double(forKey: key.stringValue)
    }

    private func value<T>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key.stringValue) as? T
    }

    // MARK: - Getting values associated with the specified String key
    func value<T>(forKey key: String) -> T? {
        return object(forKey: key) as? T
    }

    // MARK : Clearing UserDefaults
    /// Deletes the stored value associated with the specified String key
    func clear(_ key: String) {
        removeObject(forKey: key)
    }

    /// Deletes the stored value associated with the specified DefaultsKey
    func clear<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key.stringValue)
    }

    /// Deletes every stored value in UserDefaults
    func clearAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            removePersistentDomain(forName: appDomain)
        }
    }
}

public class DefaultsKeys { fileprivate init() {} }

public class DefaultsKey<T> : DefaultsKeys {
    public let stringValue : String
    public init(_ value: String) {
        self.stringValue = value
    }
}
