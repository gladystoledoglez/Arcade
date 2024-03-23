//
//  ArcadeService.swift
//  FinalProject

import Foundation

enum APIError: Error {
    case noInternetConnection
    case serverError(statusCode: Int)
}

class ArcadeService {
    let baseURL = "https://www.freetogame.com/api/games"
    
    func fetchGames() async throws -> [Arcade] {
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError(statusCode: 500)
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode([Arcade].self, from: data)
        } else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
    }
}
