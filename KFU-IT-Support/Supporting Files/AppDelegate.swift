//
//  AppDelegate.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 26.03.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Public properties

    var window: UIWindow?

//    private lazy var rootFlowCoordinator = RootFlowCoordinator()

    // MARK: Public methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()

        self.window = window

//        rootFlowCoordinator.start(animated: true, in: self.window ?? window)

//        FirebaseApp.configure()

        return true
    }
}

