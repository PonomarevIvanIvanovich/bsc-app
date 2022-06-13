//
//  Router.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation
import UIKit

final class NoteRouter {

    weak var viewController: UIViewController?
    let dataStore: NoteDataStore

    init(dataStore: NoteDataStore) {
        self.dataStore = dataStore
    }
}

private extension NoteRouter {
//    func passDataTo_() {
//        source: CounterDataStore,
//        destination: inout SomewhereDataStore
//    ) {
//    }
}

extension NoteRouter: NoteRoutingLogic {

}
