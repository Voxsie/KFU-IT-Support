//
//  UserDefaultsManager.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 24.04.2024.
//

import Foundation

class UserDefaultManager: NSObject {

    static let shared = UserDefaultManager()
    private let userDefaults: UserDefaults?

    private override  init() {
        self.userDefaults = UserDefaults.standard
    }

    func remove(for key: UserDefaultsKey) {
        self.userDefaults?.removeObject(forKey: key.value)
        self.userDefaults?.synchronize()
    }
    // Genaric is much easier to handle in code
    func set<T>(_ object: T, for key: UserDefaultsKey) {
        self.userDefaults?.set(object, forKey: key.value)
        self.userDefaults?.synchronize()
    }
    // Genaric is much easier to handle in code
    func get<T>(for key: UserDefaultsKey) -> T? {
        let result = self.userDefaults?.object(forKey: key.value) as? T
        return result
    }

    func getBool(for key: UserDefaultsKey) -> Bool {
        return self.userDefaults?.bool(forKey: key.value) ?? false
    }

    func object(for key: UserDefaultsKey) -> Any? {
        let result = self.userDefaults?.object(forKey: key.value)
        return result
    }

    static func purge() {
        let keys = UserDefaultsKey.allCases
        keys.forEach {
            let excluded = UserDefaultsKey.excludedCases.contains($0)
            if excluded {
                print("Excluded case: \($0.value)")
            } else {
                UserDefaultManager.shared.remove(for: $0)
            }
        }
    }
}

enum UserDefaultsKey: String, CaseIterable {

    case offlineMode
    // no need to purge
    case voidKey = "void"

    // Helper
    static var excludedCases: [UserDefaultsKey] = [
        .voidKey
    ]

    var value: String {
        return self.rawValue
    }

}
