//
//  NetworkTask.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 23.04.2023.
//

import UIKit

@discardableResult
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
        catch {
            completion(.failure(error))
        }
    }
    task.resume()
    return task
}

struct NoData: Error {}

extension UIImageView {
    @discardableResult
    func loadImage(from stringURL: String, completion: @escaping () -> Void = {}) -> URLSessionDataTask? {
        guard let url = URL(string: stringURL) else { return nil }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.image = image
                completion()
            }
        }
        task.resume()
        return task
    }
    
}
