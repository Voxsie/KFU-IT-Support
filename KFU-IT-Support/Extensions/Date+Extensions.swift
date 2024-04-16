//
//  Date+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 13.04.2024.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
}

extension Date {
    static func adding(years: Int, months: Int, days: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = years
        dateComponents.month = months
        dateComponents.day = days
        return calendar.date(byAdding: dateComponents, to: self.init())
    }
}
