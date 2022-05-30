//
//  Worker.swift
//  bsc-app
//
//  Created by Иван Пономарев on 16.05.2022.
//

import Foundation
import UIKit

final class Worker {
    
    var parsArray = [NotesModelResponse]()
    private let session = URLSession(configuration: .default)
    private let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/ios-test-ce687.appspot.com/o/Empty.json?alt=media&token=d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
    
    func request(complition: @escaping (Result<[NotesModelResponse], NotesModelResponse.NotesErrors>) -> Void) {
        guard let url = url else { return }
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
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
