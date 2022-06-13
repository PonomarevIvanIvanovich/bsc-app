//
//  NotesListInteractor.swift
//  bsc-app
//
//  Created by Иван Пономарев on 13.06.2022.
//

import Foundation

final class NotesListInteractor {
    private let presenter: NotesListPresenter
    private let filter = FilterNotes()
    private let notesStorage = NotesStorage.self

    init(presenter: NotesListPresenter) {
        self.presenter = presenter
    }

    func request(_ request: NotesListSceneModel.InitForm.Request) {
        filter.loadNotes { [weak self] in
            guard let self = self else { return }
            self.presenter.present(NotesListSceneModel.InitForm.Response(notes: self.filter.arrayModel))
        }
    }

    func request(_ request: NotesListSceneModel.DeleteItems.Request) {
        var array = notesStorage.notesModel
        for indexPath in request.arraySorted {
            if filter.arrayModel[indexPath.row].isSave {
                array?.remove(at: indexPath.row)
            }
            filter.arrayModel.remove(at: indexPath.row)
        }
        notesStorage.notesModel = array
        presenter.present(NotesListSceneModel.DeleteItems.Response(notes: filter.arrayModel))
    }
}
