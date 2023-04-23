//
//  NetworkTask.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 23.04.2023.
//

import Foundation

func request<T: Decodable>(with url: String, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
    guard let url = URL(string: url) else { return nil }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        let completion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NoData()))
            return
        }
        do {
            let result = try JSONDecoder().decode(model, from: data)
            completion(.success(result))
        }
        catch let error {
            completion(.failure(error))
        }
    }
    task.resume()
    return task
}

struct NoData: Error {}
