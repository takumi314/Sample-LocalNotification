//
//  AppDelegate.swift
//  Sample-LocalNotification
//
//  Created by NishiokaKohei on 2018/06/05.
//  Copyright © 2018年 Takumi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // Call after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Reset the budge into zero
        application.applicationIconBadgeNumber = 0

        if #available(iOS 10, *) {
            // The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
            UNUserNotificationCenter.current().delegate = self

            // 通知の許可を得る
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound ]) {
                (granted: Bool, error: Error?) in
                if let e = error {
                    print(e.localizedDescription)
                } else if granted {
                    print("authorized")
                }
            }

        } else {
            application.registerForRemoteNotifications()
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        let badgeNumber = application.applicationIconBadgeNumber
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Sub title"
        content.body = "Body"
        content.badge = NSNumber(value: badgeNumber + 1)
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { (error: Error?) in
            print(error?.localizedDescription ?? "nil")
        }

    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// The method will be called on the delegate only if the application is in the foreground.
    /// If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented.
    ///    (cf. sound, badge, alert and/or in the notification list)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("The application is in the foreground.")

        // Required to present the notification
        completionHandler([.alert, .badge, .sound])

    }

    /// The method will be called on the delegate when the user responded to the notification by opening the application,
    /// dismissing the notification or choosing a UNNotificationAction.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("The user responded to the notification.")

        // Reset the budge
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}
