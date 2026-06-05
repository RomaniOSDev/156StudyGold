//
//  Formatters.swift
//  156StudyGold
//

import Foundation

enum DateFormat {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let weekday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

func formattedShortDate(_ date: Date) -> String {
    DateFormat.shortDate.string(from: date)
}

func formattedWeekday(_ date: Date) -> String {
    DateFormat.weekday.string(from: date)
}
