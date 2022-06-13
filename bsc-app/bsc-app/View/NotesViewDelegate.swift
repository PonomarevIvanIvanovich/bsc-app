//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 18.04.2022.
//

import Foundation

protocol NotesViewDelegate: AnyObject {
    func goBackButton(model: NotesListSceneModel.NotesViewModel?, index: Int?)
}
