//
//  String+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation

extension String {

    private static var digits = UnicodeScalar("0")..."9"

    var digits: String {
        String(unicodeScalars.filter(String.digits.contains))
    }

    var isNotEmptyString: Bool {
        self != ""
    }

    func ifIsEmptyStringSet(_ text: String) -> String {
        if isNotEmptyString {
            return self
        } else {
            return text
        }
    }
}
