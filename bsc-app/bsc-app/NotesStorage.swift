//
//  DateStoregу.swift
//  bsc-app
//
//  Created by Иван Пономарев on 05.04.2022.
//

import Foundation

final class NotesStorage {
    static var notesModel: [NotesModel]? {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: "saveData") as? Data,
            let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData)
                    as? [NotesModel] else { return []}
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            if let notesModel = newValue {
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: notesModel,
                                                                    requiringSecureCoding: false) {
                    defaults.set(saveData, forKey: "saveData")
                }
            }
        }
    }
 }
