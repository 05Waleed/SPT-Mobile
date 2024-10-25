//
//  HelperFunctions.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import Foundation

class HelperFunctions {
   static func getTime(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func getDate(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEE dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func convertSecondsToHoursMinutes(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h:\(minutes)min"
    }
    
    static func convertWalkSecondsToMinutes(seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        return "\(minutes)"
    }
}

