//
//  Presenter.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation

final class NotePresenter {
    weak var view: NoteDisplayLogic?
}

extension NotePresenter: NotePresentationLogic {

//    func presentInitForm(_ response: NoteCleanModel.InitForm.Response) {
//        view?.displayInitForm(NoteCleanModel.InitForm.ViewModel())
//    }
}
