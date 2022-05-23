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
    var isSave: Bool
    var isEmptyNotes: Bool {
        return header.isEmpty || notesText.isEmpty
    }

    init(header: String, notesText: String, dateNotes: Date, isSave: Bool) {
        self.header = header
        self.notesText = notesText
        self.dateNotes = dateNotes
        self.isSave = isSave
    }
}
