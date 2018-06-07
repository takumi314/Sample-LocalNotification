//
//  UNNotificationResponseExtension.swift
//  Sample-LocalNotification
//
//  Created by NishiokaKohei on 2018/06/08.
//  Copyright © 2018年 Takumi. All rights reserved.
//

import UserNotifications

enum UserAction {
    case `default`
    case dismiss
    case snooze
    case stop
}

// カスタムアクションの定義
enum NotificationAction {
    static let snooze = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop", options: UNNotificationActionOptions.foreground)
    static let stop = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
}

// カテゴリの定義
enum NotificationCategory {
    static let genral = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
    static let expired = UNNotificationCategory(identifier: "TIMER_EXPIRED", actions: [], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
}

extension UNNotificationResponse {

    var userAction: UserAction {
        get {
            switch self.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                return .dismiss
            case UNNotificationDefaultActionIdentifier:
                return .default
            case "STOP_ACTION":
                return .stop
            case "SNOOZE_ACTION":
                return .snooze
            default:
                fatalError()
            }
        }
    }

}
