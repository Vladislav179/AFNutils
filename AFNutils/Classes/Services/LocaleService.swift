//
//  LocaleService.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension DefaultsKeys {
    static let localeLanguage               = DefaultsKey<String>("localeLanguage")
}

final class LocaleService {

    static var defaultLang = "en"
    static var Lang: String = UserDefaults.standard[.localeLanguage] ?? defaultLang {
        didSet {
            updateLocaleController(locale: Lang)
            UserDefaults.standard[.localeLanguage] = Lang

        }
    }

    static func updateLocaleController(_ controller: UIViewController? = UIApplication.presentedViewController(), locale: String = Lang) {

        let subviews = controller?.view.allSubViewsOf(type: UIView.self)
        for view in subviews ?? [] {
            if !((view as? XIBLocalizable)?.localizedKey?.isEmpty ?? true) {
                (view as? XIBLocalizable)?.localizedLang = locale
            }
        }
    }
}
