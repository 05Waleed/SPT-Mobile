//
//  NetworkManager.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import UIKit

// NetworkManager is responsible for handling all network-related tasks.
class NetworkManager {
    // Shared instance for singleton usage across the app.
    static let shared = NetworkManager()
    
    // Private initializer to prevent creating multiple instances of NetworkManager.
    private init() {}
    
    /// Function to set up a URL with query parameters.
    ///
    /// - Parameters:
    ///   - from: The starting location (as a string).
    ///   - to: The destination location (as a string).
    /// - Returns: A URL constructed with the provided parameters.
    func setupURL(from: String, to: String) -> URL? {
        // Encoding parameters to be URL-safe.
        let characterSet = CharacterSet.urlQueryAllowed
        let fromText = from.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let toText = to.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let urlString = "https://timetable.search.ch/api/route.json?from=\(fromText)&to=\(toText)"
        
        // Returning the URL object or nil if it's invalid.
        return URL(string: urlString)
    }
    
    /// Generic function to perform a network request and decode the response into a data model.
    ///
    /// - Parameters:
    ///   - url: The URL for the network request.
    ///   - isFetching: A closure to indicate whether fetching has started or stopped.
    ///   - completion: A closure with a `Result` type containing either a success with the decoded data or a failure with an error.
    ///   - T: The expected model type that conforms to `Decodable`.
    func performRequest<T: Decodable>(with url: URL, isFetching: @escaping (Bool) -> Void, completion: @escaping (Result<T, Error>) -> Void) {
        // Indicate that fetching has started.
        isFetching(true)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Indicate that fetching has stopped.
            isFetching(false)
            
            // Handle errors, if any.
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Check for a valid HTTP response.
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    let responseError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from server."])
                    completion(.failure(responseError))
                }
                return
            }
            
            // Check if the status code is in the 200-299 range (successful response).
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server. Status code: \(httpResponse.statusCode)"])
                    completion(.failure(statusCodeError))
                }
                return
            }
            
            // Check if data is present.
            guard let data = data else {
                DispatchQueue.main.async {
                    let dataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server."])
                    completion(.failure(dataError))
                }
                return
            }
            
            // Try to decode the response data into the expected model.
            do {
                // Print the raw JSON response for debugging purposes.
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("MAIN JSON Response: \(jsonString)")
                }
                
                // Use JSONDecoder to decode the data into the specified model.
                let decoder = JSONDecoder()
                let dataModel = try decoder.decode(T.self, from: data)
                
                // On success, pass the decoded model to the completion handler.
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                // On failure, pass the decoding error to the completion handler.
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        // Start the network task.
        task.resume()
    }
}
