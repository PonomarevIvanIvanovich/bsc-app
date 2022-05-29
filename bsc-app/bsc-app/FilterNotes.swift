//
//  FilterNotes.swift
//  bsc-app
//
//  Created by Иван Пономарев on 21.05.2022.
//

import Foundation

final class FilterNotes {

    var arrayModel = [NotesModel]()
    private var notesModel = [NotesModel]()
    private var parsNotesModel = [ParsModel]()

    init() {
        filter(notesModel: notesModel, parsNotesModel: parsNotesModel)
        print("FilterNotes init")
    }

    deinit {
        print("FilterNotes deinit")
    }

    func loadNotes(completion: @escaping() -> Void) {
        if let saveNotesModel = NotesStorage.notesModel {
            notesModel = saveNotesModel
            filter(notesModel: notesModel, parsNotesModel: parsNotesModel)
        }
        let worker = Worker()
        worker.request(complition: { (welcomeNotes, _) in
            guard let welcome = welcomeNotes else { return }
            self.parsNotesModel = welcome
            self.filter(notesModel: self.notesModel, parsNotesModel: self.parsNotesModel)
            completion()
        })
    }

    func filter(notesModel: [NotesModel], parsNotesModel: [ParsModel]) {
        var newModelArray = notesModel
        for newModel in parsNotesModel {
            let model = NotesModel(
                header: newModel.header,
                notesText: newModel.text,
                dateNotes: newModel.date,
                isSave: false)
            newModelArray.append(model)
        }
        self.arrayModel = newModelArray
    }
}
