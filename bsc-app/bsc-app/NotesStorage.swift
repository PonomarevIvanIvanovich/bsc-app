//
//  DateStoregу.swift
//  bsc-app
//
//  Created by Иван Пономарев on 05.04.2022.
//

import Foundation

final class NotesStorage {
    static let key = "saveData"
    static var notesModel: [NotesModel]? {
        get {
            guard let savedData = UserDefaults.standard.data(forKey: key),
                  let decodedModel = try? JSONDecoder().decode([NotesModel].self, from: savedData)
            else {return []}
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            if let notesModel = newValue {
                if let saveData = try? JSONEncoder().encode(notesModel) {
                    defaults.set(saveData, forKey: key)
                }
            }
        }
    }
}
