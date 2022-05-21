//
//  StructNote.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation

struct WelcomeNotes: Codable {
    let header, text: String
    let date: Date
}

typealias Welcome = [WelcomeNotes]
