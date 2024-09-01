//
//  NetworkManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func setupURL(from: String, to: String, selectedDate: Date? = nil) -> URL? {
        let characterSet = CharacterSet.urlQueryAllowed
        let fromText = from.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let toText = to.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        
        if let selectedDate = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: selectedDate)
            return URL(string: "https://timetable.search.ch/api/route.json?from=\(fromText)&to=\(toText)&date=\(formattedDate)")
        } else {
            return URL(string: "https://timetable.search.ch/api/route.json?from=\(fromText)&to=\(toText)")
        }
    }
    
    func performRequest(with url: URL, completion: @escaping (Result<ModelForCurrentLocation, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCodeError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server."])
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let dataModel = try decoder.decode(ModelForCurrentLocation.self, from: data)
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("MAIN JSON Response: \(jsonString)")
                    }
                    DispatchQueue.main.async {
                        completion(.success(dataModel))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
}

