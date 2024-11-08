//
//  SelectedDateAndTime.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 08.11.2024.
//

import Foundation

struct SelectedDateAndTime {
    let date: Date
    let time: Date
    
    // Formatter for API
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    // Formatter for UI short date display (e.g., "Mon 04.11")
    private let uiShortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd.MM"
        return formatter
    }()
    
    // Formatter for UI time display (e.g., "17:16")
    private let uiTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    // Formatter for UI full date display (e.g., "Monday 04.11.2024")
    private let uiFullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd.MM.yyyy"
        return formatter
    }()
    
    var apiDateString: String {
        apiDateFormatter.string(from: date)
    }
    
    var shortDateString: String {
        uiShortDateFormatter.string(from: date)
    }
    
    var timeString: String {
        uiTimeFormatter.string(from: time)
    }
    
    var fullDateString: String {
        uiFullDateFormatter.string(from: date)
    }
}
