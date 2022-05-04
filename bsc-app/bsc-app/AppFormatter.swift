//
//  AppFormatter.swift
//  bsc-app
//
//  Created by Иван Пономарев on 28.04.2022.
//

import Foundation

final class AppDateFormatter {

    private let formatter = DateFormatter()

    func format(_ date: Date, dateFormat: String) -> String {
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
}
