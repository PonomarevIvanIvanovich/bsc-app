//
//  StructNote.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation

struct NotesModelResponse: Codable {
    let header: String
    let text: String
    let date: Date

    enum NotesErrors: Error {
        case emptyData
        case parsingError
    }
}
