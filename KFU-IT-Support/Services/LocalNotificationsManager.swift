//
//  LocalNotificationsManager.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 26.05.2024.
//

import Foundation
import UserNotifications

class LocalNotificationsManager: NSObject {

    static let shared = LocalNotificationsManager()

    private override init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("Failed to request authorization for local notifications: \(error)")
            } else if granted {
                print("Authorization granted for local notifications")
            } else {
                print("Authorization denied for local notifications")
            }
        }
    }

    func scheduleNotification(
        title: String,
        body: String,
        date: Date,
        identifier: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            ),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for date: \(date)")
            }
        }
    }

    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
