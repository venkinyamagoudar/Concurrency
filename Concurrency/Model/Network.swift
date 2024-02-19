//
//  Network.swift
//  Concurrency
//
//  Created by Venkatesh Nyamagoudar on 8/23/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case notConnectedToInternet
    case timedOut
    case responseError(HTTPURLResponse)
    case noData
    case decodingError
}

class Network {
    
    static func makeNetworkRequest(with urlString: String, completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                    case .notConnectedToInternet :
                        completion(.failure(NetworkError.notConnectedToInternet))
                    case .timedOut:
                        completion(.failure(NetworkError.timedOut))
                    default:
                        completion(.failure(error))
                }
                return
            }
            
            if let response = (response as? HTTPURLResponse), response.statusCode != 200 {
                completion(.failure(NetworkError.responseError(response)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }
    
    static func parseTheData<T: Codable>(_ data: Data, completion: @escaping (Result<T,Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch NetworkError.decodingError {
            completion(.failure(NetworkError.decodingError))
        } catch NetworkError.noData {
            completion(.failure(NetworkError.noData))
        }catch {
            completion(.failure(error))
        }
        return
    }
}
