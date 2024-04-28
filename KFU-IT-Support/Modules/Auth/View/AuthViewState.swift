//
//  AuthViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

enum AuthViewState {
    case loading
    case display
    case error(NotificationDisplayData)
}
