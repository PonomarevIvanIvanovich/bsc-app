//
//  FilterNotes.swift
//  bsc-app
//
//  Created by Иван Пономарев on 21.05.2022.
//

import Foundation
import UIKit

final class FilterNotes {

    var arrayModel = [NotesModel]()
    private var notesModel = [NotesModel]()
    private var parsNotesModel = [NotesModelResponse]()

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
        worker.request(complition: { result in
            switch result {
            case .success(let result):
                self.parsNotesModel = result
            case .failure(let error):
                print(error)
            }

            self.filter(notesModel: self.notesModel, parsNotesModel: self.parsNotesModel)
            completion()
        })
    }

    func filter(notesModel: [NotesModel], parsNotesModel: [NotesModelResponse]) {
        var newModelArray = notesModel
        for newModel in parsNotesModel {
            let model = NotesModel(
                header: newModel.header,
                notesText: newModel.text,
                dateNotes: newModel.date,
                userShareIcon: newModel.userShareIcon,
                isSave: false)
            newModelArray.append(model)
        }
        self.arrayModel = newModelArray
    }
}
