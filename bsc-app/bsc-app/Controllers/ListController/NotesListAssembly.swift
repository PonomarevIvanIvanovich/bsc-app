//
//  NotesListAssembly.swift
//  bsc-app
//
//  Created by Иван Пономарев on 13.06.2022.
//

import Foundation
import UIKit

enum NotesListAssembly {
    static func build() -> UIViewController {
        let presenter = NotesListPresenter()
        let interactor = NotesListInteractor(presenter: presenter)
        let view = NotesListViewController(nibName: nil, bundle: nil)
        view.interactor = interactor
        presenter.view = view
        return view
    }
}
