//
//  Localizable.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String {
    func localized(_ lang: String) -> String {

        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension String: Localizable {
    var localized: String {

        if let remoute = RemoteConfigService.shared.stringForKey(self){
            let newText = remoute.replacingOccurrences(of: "\\n", with: "\n")
            return newText
        }

        return NSLocalizedString(self, comment: "")
    }
}

protocol XIBLocalizable: class {
    var localizedKey: String? { get set }
    var localizedLang: String? { get set }
}

extension UILabel: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            if let key = localizedKey {
                text = key.localized(lang ?? LocaleService.Lang)
            }
        }
    }

    @IBInspectable var localizedKey: String? {
        get { return self.accessibilityIdentifier }
        set(key) {
            text = key?.localized(LocaleService.Lang)
            self.accessibilityIdentifier = key
        }
    }
}
extension UIButton: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            if let key = localizedKey {
                setTitle(key.localized(lang ?? LocaleService.Lang), for: .normal)
            }
        }
    }
    @IBInspectable var localizedKey: String? {
        get { return self.accessibilityIdentifier }
        set(key) {
            setTitle(key?.localized(LocaleService.Lang), for: .normal)
            self.accessibilityIdentifier = key
        }
    }
}
extension UITextView: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            text = localizedKey?.localized(lang ?? LocaleService.Lang)
        }
    }

    @IBInspectable var localizedKey: String? {
        get { return self.accessibilityIdentifier }
        set(key) {
            text = key?.localized(LocaleService.Lang)
        }
    }
}
extension UITextField: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            text = localizedKey?.localized(lang ?? LocaleService.Lang)
        }
    }

    @IBInspectable var localizedKey: String? {
        get { return self.accessibilityIdentifier }
        set(key) {
            text = key?.localized(LocaleService.Lang)
        }
    }
    @IBInspectable var localizedPlaceholderKey: String? {
        get { return nil }
        set(key) {
            //            placeholder = key?.localized(LocaleService.defaultLang)
            placeholder = key?.localized(LocaleService.Lang)
        }
    }
}
extension UINavigationItem: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            title = localizedKey?.localized(lang ?? LocaleService.Lang)
        }
    }

    @IBInspectable var localizedKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized(LocaleService.Lang)
        }
    }
}
extension UIBarButtonItem: XIBLocalizable {
    var localizedLang: String? {
        get { return nil }
        set(lang) {
            title = localizedKey?.localized(lang ?? LocaleService.Lang)
        }
    }

    @IBInspectable var localizedKey: String? {
        get { return self.accessibilityIdentifier }
        set(key) {
            title = key?.localized(LocaleService.Lang)
        }
    }
}

