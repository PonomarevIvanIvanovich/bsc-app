//
//  Worker.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation
import UIKit

protocol WorkerType {
    func request(complition: @escaping ([ParsModel]?, Error?) -> Void)
}

final class Worker: WorkerType {

    var parsArray = [ParsModel]()
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/ios-test-ce687.appspot.com/o/lesson8.json?alt=media&token=215055df-172d-4b98-95a0-b353caca1424")

    init() {
        print("Worker init")
    }

    deinit {
        print("Worker deinit")

    }

    func request(complition: @escaping ([ParsModel]?, Error?) -> Void) {
        guard let url = url else { return }
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    complition(nil, error)
                    return
                }
                guard let data = data else {
                    complition(nil, nil)
                    return
                }
                do {
                    let response =  try JSONDecoder().decode([ParsModel].self, from: data)
                    complition(response, nil)
                } catch let jsonError {
                    complition(nil, jsonError)
                }
            }
        }.resume()
    }
}
