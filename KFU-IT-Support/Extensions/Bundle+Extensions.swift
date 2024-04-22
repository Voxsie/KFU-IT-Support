//
//  Bundle+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 17.04.2024.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
