//
//  StructNote.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation

struct ParsModel: Codable {
    let header: String
    let text: String
    let date: Date
    let userShareIcon: String?
}
