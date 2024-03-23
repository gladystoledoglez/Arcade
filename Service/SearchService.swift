//
//  SearchService.swift
//  FinalProject

import Foundation

class SearchService {
    
    let baseURL = "https://www.freetogame.com/api/games"
    
    func fetchGamesBySearchTerm(searchTerm: String) async throws -> [Arcade] {
        var searchURLString = baseURL
        
        if searchTerm.contains(" ") { // Buscar por categoria
            let escapedCategory = searchTerm.replacingOccurrences(of: " ", with: "%20")
            searchURLString += "?category=\(escapedCategory)"
        } else { // Buscar por nome do jogo
            let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
            searchURLString += "?name=\(escapedSearchTerm)"
        }
        
        guard let url = URL(string: searchURLString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
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

