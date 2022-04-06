//
//  NotesModel.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation

class NotesModel: NSObject, NSCoding {

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

    func encode(with coder: NSCoder) {
        coder.encode(header, forKey: "header")
        coder.encode(notesText, forKey: "notesText")
        coder.encode(dateNotes, forKey: "dateNotes")
    }

    required init?(coder: NSCoder) {
        header = coder.decodeObject(forKey: "header") as? String ?? ""
        notesText = coder.decodeObject(forKey: "notesText") as? String ?? ""
        dateNotes = coder.decodeObject(forKey: "dateNotes") as? String ?? ""
    }
}
