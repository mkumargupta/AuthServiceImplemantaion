//
//  APIManager.swift
//  DailyUseThingProject
//
//  Created by Manoj Kumar Gupta on 08/11/24.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func performRequest(endpoint: String, method: String = "GET", parameters: [String: Any]? = nil) async throws -> Data {
        
        // Ensure we have a valid token
        let token = try await AuthServiceImpl.shared.getBearerToken()
        
        // Construct the request
        let url = URL(string: "https://example.com/api/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add request body if there are parameters
        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}

