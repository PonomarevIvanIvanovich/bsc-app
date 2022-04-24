//
//  NotesModel.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation

struct NotesModel: Codable {

    var header: String
    var notesText: String
    var dateNotes: Date
    var isEmptyNotes: Bool {
        return header.isEmpty || notesText.isEmpty
    }

    init(header: String, notesText: String, dateNotes: Date) {
        self.header = header
        self.notesText = notesText
        self.dateNotes = dateNotes
    }
}
