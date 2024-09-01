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
    
    // Function to set up the URL with parameters
    func setupURL(from: String, to: String, selectedDate: Date?, selectedTime: Date?) -> URL? {
        let characterSet = CharacterSet.urlQueryAllowed
        let fromText = from.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let toText = to.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""

        var urlString = "https://timetable.search.ch/api/route.json?from=\(fromText)&to=\(toText)"
        
        if let selectedDate = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: selectedDate)
            urlString += "&date=\(formattedDate)"
        }
        
        if let selectedTime = selectedTime {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let formattedTime = timeFormatter.string(from: selectedTime)
            urlString += "&time=\(formattedTime)"
        }
        
        return URL(string: urlString)
    }

    // Function to perform the network request
    func performRequest(with url: URL, completion: @escaping (Result<ModelForCurrentLocation, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    let responseError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from server."])
                    completion(.failure(responseError))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server. Status code: \(httpResponse.statusCode)"])
                    completion(.failure(statusCodeError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    let dataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server."])
                    completion(.failure(dataError))
                }
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("MAIN JSON Response: \(jsonString)")
                }
                let decoder = JSONDecoder()
                let dataModel = try decoder.decode(ModelForCurrentLocation.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
