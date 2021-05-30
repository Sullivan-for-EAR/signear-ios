//
//  AppDelegate.swift
//  signear
//
//  Created by 신정섭 on 2021/05/02.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        switchRootViewToInitialView()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func switchRootViewToInitialView() {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        guard let rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController else { return }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first,
               let windowScene = (scene as? UIWindowScene) {
                let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                self.window = window
            }
        } else {
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    func switchRootViewToReservationListView() {
        let storyboard = UIStoryboard.init(name: "Reservation", bundle: nil)
        guard let rootViewController = storyboard.instantiateViewController(withIdentifier: "ReservationListViewController") as? ReservationListViewController else { return }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first,
               let windowScene = (scene as? UIWindowScene) {
                let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                self.window = window
            }
        } else {
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}

