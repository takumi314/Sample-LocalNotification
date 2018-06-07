//
//  NotificationReceiver.swift
//  Sample-LocalNotification
//
//  Created by NishiokaKohei on 2018/06/07.
//  Copyright © 2018年 Takumi. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationReceiver: NSObject {

    static let shared = NotificationReceiver()

    private var center: UNUserNotificationCenter
    private var requests = [String]()

    init(_ center: UNUserNotificationCenter = .current()) {
        self.center = center
        super.init()
    }

    func setup() {
        center.delegate = self

        // 通知の許可を得る
        center.requestAuthorization(options: [.alert, .badge, .sound ]) {
            (granted: Bool, error: Error?) in
            if let e = error {
                print(e.localizedDescription)
            } else if granted {
                print("authorized")
            }
        }
    }

    func set(_ request: UNNotificationRequest) {
        requests.append(request.identifier)
        center.add(request) { (error: Error?) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }

    func abort(with identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func reset() {
        center.removeAllPendingNotificationRequests()
    }

    func resetBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

extension NotificationReceiver: UNUserNotificationCenterDelegate {

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

        /// each executions up to user's action.
        switch response.userAction {
        case .dismiss:
            print("the user dismissed the notification")
            break
        case .default:
            print("the user opened the application from the notification")
            break
        case .snooze:
            break
        case .stop:
            break
        }

        // Reset the budge
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

