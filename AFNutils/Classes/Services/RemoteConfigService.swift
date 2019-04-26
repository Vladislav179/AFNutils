//
//  RemoteConfigService.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation
#if canImport(Firebase)
import Firebase
#endif
#if canImport(FirebaseRemoteConfig)
import FirebaseRemoteConfig
#endif

final class RemoteConfigService {
    static var shared = RemoteConfigService()
    
    #if canImport(FirebaseRemoteConfig)
        let remoteConfig = RemoteConfig.remoteConfig()
    #endif

    fileprivate func configSetting() {
        #if DEBUD
            let devSettings = RemoteConfigSettings(developerModeEnabled: true)!
            remoteConfig.configSettings = devSettings
        #endif
    }

    func stringForKey(_ key: String) -> String? {

        #if canImport(FirebaseRemoteConfig)
            guard let valueFromServer = remoteConfig.configValue(forKey: key).stringValue else { return nil }
            return valueFromServer.isEmpty ? nil : valueFromServer
        #else
            return nil
        #endif
    }

    func boolForKey(_ key: String) -> Bool? {
        #if canImport(FirebaseRemoteConfig)
            return remoteConfig.configValue(forKey: key).boolValue
        #else
            return nil
        #endif
    }

    func numberForKey(_ key: String) -> NSNumber? {
        #if canImport(FirebaseRemoteConfig)
            return remoteConfig.configValue(forKey: key).numberValue
        #else
            return nil
        #endif
    }

    func fetchData() {
        configSetting()
        #if canImport(FirebaseRemoteConfig)
            remoteConfig.fetch(withExpirationDuration: 10) { (status, error) in
                let activate = RemoteConfig.remoteConfig().activateFetched()
                print("Fetched: \(status), Error \(String(describing: error)), Activate: \(activate)")

                if status == .success {
                    print("Config fetched!")
                    self.remoteConfig.activateFetched()
                } else {
                    print("Config not fetched")
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                }
            }
        #endif
    }
}

