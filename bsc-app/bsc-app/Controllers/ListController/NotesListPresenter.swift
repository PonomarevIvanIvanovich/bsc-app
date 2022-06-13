//
//  NotesListPresenter.swift
//  bsc-app
//
//  Created by Иван Пономарев on 13.06.2022.
//

import Foundation

final class NotesListPresenter {
    var view: NotesListViewController?

    private let appDate = AppDateFormatter()
    func present(_ present: NotesListSceneModel.InitForm.Response) {
        let notes = map(present.notes)
        view?.display(NotesListSceneModel.InitForm.ViewModel(notesViewModels: notes))
    }

    func present(_ present: NotesListSceneModel.DeleteItems.Response) {
        let notes = map(present.notes)
        view?.display(NotesListSceneModel.DeleteItems.ViewModel(notesViewModels: notes))
    }

    private func map(_ notes: [NotesModel]) -> [NotesListSceneModel.NotesViewModel] {
        notes.map { note -> NotesListSceneModel.NotesViewModel in
            let dateNotes = appDate.format(note.dateNotes, dateFormat: "dd.MM.yyyy")
            return NotesListSceneModel.NotesViewModel(
                header: note.header,
                notesText: note.notesText,
                dateNotes: dateNotes,
                isSave: note.isSave,
                userShareIcon: note.userShareIcon,
                isEmptyNotes: note.isEmptyNotes
            )
        }
    }
}
