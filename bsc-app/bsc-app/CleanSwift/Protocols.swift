//
//  Protocols.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation

protocol NoteDataPassing {
    var dataStore: NoteDataStore { get }
}

protocol NoteDataStore {}

protocol NoteBusinessLogic {
//    func requestInitForm(_ request: NoteCleanModel.InitForm.Request)
}

protocol NoteWorkerLogic {}

protocol NotePresentationLogic {
//    func presentInitForm(_ response: NoteCleanModel.InitForm.Response)
}

protocol NoteDisplayLogic: AnyObject {
//    func displayInitForm(_ viewModel: NoteCleanModel.InitForm.ViewModel)
}

protocol NoteRoutingLogic {}
