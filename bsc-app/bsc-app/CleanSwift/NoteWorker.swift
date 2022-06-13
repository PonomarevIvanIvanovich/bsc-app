//
//  CounterWorker.swift
//  bsc-app
//
//  Created by Иван Пономарев on 06.06.2022.
//

import Foundation

final class NoteWorker: NoteWorkerLogic {

    var parsArray = [NotesModelResponse]()
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/ios-test-ce687.appspot.com/o/lesson8.json?alt=media&token=215055df-172d-4b98-95a0-b353caca1424")

    init() {
        print("Worker init")
    }

    deinit {
        print("Worker deinit")
    }

    func request(complition: @escaping (Result<[NotesModelResponse], NotesModelResponse.NotesErrors>) -> Void) {
        guard let url = url else { return }
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                NotesListViewController.activityIndicator.stopAnimating()
                guard error == nil else {
                    complition(.failure(.parsingError))
                    return
                }
                guard let data = data else {
                    complition(.failure(.emptyData))
                    return
                }
                do {
                    let response =  try JSONDecoder().decode([NotesModelResponse].self, from: data)
                        complition(.success(response))

                } catch _ {
                    complition(.failure(.parsingError))
                }
            }
        }.resume()
    }
}
