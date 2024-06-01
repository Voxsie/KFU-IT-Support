//
//  AppDelegate.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 26.03.2024.
//

import CoreData
import FirebaseCore
import FirebaseCrashlytics
import Swinject
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Private properties

    let pollingManager = ShortPollingManager(interval: 900)

    private lazy var rootFlowCoordinator = RootFlowCoordinator(
        userDefaults: UserDefaultManager.shared
    )

    // MARK: Public properties

    var window: UIWindow?

    // MARK: Public methods

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        pollingManager.stopPolling()
        pollingManager.repository = Repository()

        let window = UIWindow()
        self.window = window

        rootFlowCoordinator.start(animated: true, in: self.window ?? window)

        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        pollingManager.startPolling()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "KFU_IT_Support")
        container.loadPersistentStores(completionHandler: { _, _ in})
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
