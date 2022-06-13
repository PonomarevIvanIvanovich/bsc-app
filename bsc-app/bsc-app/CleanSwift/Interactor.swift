//
//  Interactor.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation

final class NoteInteractor {
    private let presenter: NotePresentationLogic
    private let worker: NoteWorkerLogic

    init(
        presenter: NotePresentationLogic,
        worker: NoteWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }
}

extension NoteInteractor: NoteDataStore {
}

extension NoteInteractor: NoteBusinessLogic {
//    func requestInitForm(_ request: NoteCleanModel.InitForm.Request) {
//        DispatchQueue.main.async {
//            worker.fetchData() {
//                self.presenter.presentInitForm(NoteCleanModel.InitForm.Response())
//            }
//        }
//    }
}
