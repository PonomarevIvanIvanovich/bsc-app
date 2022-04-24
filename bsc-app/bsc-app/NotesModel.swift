//
//  NotesModel.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation

class NotesModel: Codable {

    var header: String
    var notesText: String
    var dateNotes: String?
    var isEmpt: Bool {
        return header.isEmpty || notesText.isEmpty
    }

    init(header: String, notesText: String, dateNotes: String) {
        self.header = header
        self.notesText = notesText
        self.dateNotes = dateNotes
    }
}
