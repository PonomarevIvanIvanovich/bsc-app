//
//  Worker.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation
import UIKit

protocol WorkerType {
    func request(complition: @escaping ([WelcomeNotes]?, Error?) -> Void)
}

final class Worker: WorkerType {

    var parsArray = [WelcomeNotes]()
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/ios-test-ce687.appspot.com/o/Empty.json?alt=media&token=d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")

    func request(complition: @escaping ([WelcomeNotes]?, Error?) -> Void) {
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
                    let response =  try JSONDecoder().decode([WelcomeNotes].self, from: data)
                    complition(response, nil)
                } catch let jsonError {
                    complition(nil, jsonError)
                }
            }
        }.resume()
    }
}
