//
//  Counter.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation

enum NotesListSceneModel {
    enum InitForm {
        struct Request {}
        struct Response {
            let notes: [NotesModel]
        }
        struct ViewModel {
            let notesViewModels: [NotesViewModel]
        }
    }

    enum DeleteItems {
        struct Request {
            let arraySorted: [IndexPath]
        }
        struct Response {
            let notes: [NotesModel]
        }
        struct ViewModel {
            let notesViewModels: [NotesViewModel]
        }
    }

//    enum SelectCell {
//        struct Request {
//            let isEditing: Bool
//        }
//        struct Presenter {}
//        struct ViewModel {}
//    }

    enum SelectButton {
        struct Request {}
        struct Presenter {}
        struct ViewModel {}
        struct Route {}
    }

    struct NotesViewModel {
        let header: String
        let notesText: String
        let dateNotes: String
        let isSave: Bool
        let userShareIcon: String?
        let isEmptyNotes: Bool
    }
//        struct Request {
//            var header: String
//            var notesText: String
//            var dateNotes: Date
//            var isSave: Bool
//            var userShareIcon: String?
//            var isEmptyNotes: Bool {
//                return header.isEmpty || notesText.isEmpty
//            }
//
//            init(header: String, notesText: String, dateNotes: Date, userShareIcon: String?, isSave: Bool) {
//                self.header = header
//                self.notesText = notesText
//                self.dateNotes = dateNotes
//                self.userShareIcon = userShareIcon
//                self.isSave = isSave
//            }
//        }
//
//        struct Response {
//            let header: String
//            let text: String
//            let date: Date
//            let userShareIcon: String?
//
//            enum NotesErrors: Error {
//                case emptyData
//                case parsingError
//            }
//        }
//
//        struct ViewModel {}
//    }
}
