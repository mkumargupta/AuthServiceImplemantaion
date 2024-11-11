//
//  AuthServiceImpl.swift
//  DailyUseThingProject
//
//  Created by Manoj Kumar Gupta on 08/11/24.
//

import Foundation

protocol AuthService {
    func getBearerToken() async throws -> String
}

actor AuthServiceImpl: AuthService {
    
    // Singleton instance
    static let shared = AuthServiceImpl(authURL: URL(string: "https://example.com/api/auth")!)
    
    private var tokenTask: Task<String, Error>?
    private let authURL: URL
    private var cachedToken: String?
    
    private init(authURL: URL) {
        self.authURL = authURL
    }
    
    func getBearerToken() async throws -> String {
        // Check if there's an ongoing task; if not, create a new one
        if tokenTask == nil {
            tokenTask = Task {
                try await fetchValidAuthToken()
            }
        }
        
        // Ensure tokenTask is set to nil once the task is completed or throws an error
        defer { tokenTask = nil }
        
        // Cache the token once it's fetched
        cachedToken = try await tokenTask!.value
        return cachedToken!
    }
    
    private func fetchValidAuthToken() async throws -> String {
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Replace with actual credentials
        let body = ["username": "your_username", "password": "your_password"]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let token = json?["access_token"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return token
    }
}
