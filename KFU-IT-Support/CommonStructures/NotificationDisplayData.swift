//
//  NotificationDisplayData.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 24.04.2024.
//

import UIKit

struct NotificationDisplayData {
    var title: String
    var subtitle: String
    var actions: [NotificationActionDisplayData]
}

struct NotificationActionDisplayData {
    var buttonTitle: String
    var action: () -> Void
    var style: UIAlertAction.Style
}
