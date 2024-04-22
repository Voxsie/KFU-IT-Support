//
//  DateFormatter+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 21.04.2024.
//

import Foundation

extension DateFormatter {

    func date(fromOptionalString dateString: String?) -> Date {
        guard let dateString = dateString,
              let date = self.date(from: dateString)
        else {
            return Date()
        }
        return date
    }
}
