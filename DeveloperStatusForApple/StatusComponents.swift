//
//  StatusComponents.swift
//  DeveloperStatusForApple
//
//  Created by Thomas Prezioso Jr on 4/22/22.
//

import Foundation

struct Service: Codable, Identifiable {
    var id: String {
            self.serviceName
        }
    var redirectUrl: String?
    var events: [Event]
    var serviceName: String

}

struct Event: Codable {
    let usersAffected: String?
    let epochStartDate, epochEndDate: Int?
    let messageID, statusType, datePosted, startDate: String?
    let endDate: String?
    let affectedServices: String?
    let eventStatus, message: String?

}

struct StatusComponents: Codable {
    var services: [Service]
}
