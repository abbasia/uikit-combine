//
//  NetworkService.swift
//  uikit-virta-demo
//
//  Created by abbasi on 15.3.2021.
//

import Foundation
import  Combine

enum HTTPError: LocalizedError {
    case statusCode
}

enum APIError: Error {
    case invalidBody
    case invalidEndpoint
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int)
}

struct LoginData: Codable {
    let email:String
    let code: String
}

struct Token: Decodable {
    let token:String
    let token_type:String
}


struct URLS {
    static let BaseUrl = "https://apitest.virta.fi/v4"
    static let LoginUrl = "\(BaseUrl)/auth"
    static let StationsUrl = "\(BaseUrl)/stations"
}


final class NetworkService {
    
    func fetchStations(token: String, locationContainer: LocationContainer?) -> AnyPublisher<[Station], Error>{
        
        var components = URLComponents(string: URLS.StationsUrl)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "100"),
        ]
        if (locationContainer != nil) {
            let container = locationContainer!
            components.queryItems = [
                URLQueryItem(name: "limit", value: "100"),
                URLQueryItem(name: "latMin", value: "\(container.minLat)"),
                URLQueryItem(name: "latMax", value: "\(container.maxLat)"),
                URLQueryItem(name: "longMin", value: "\(container.minLong)"),
                URLQueryItem(name: "longMax", value: "\(container.maxLong)")
            ]
        }
        
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { [self] in try validate($0.data, $0.response)}
            .decode(type: [Station].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
    func login(_ email: String, _ password: String) -> AnyPublisher<Token,Error>  {
        
        let url = URL(string: URLS.LoginUrl)!
        let encoder = JSONEncoder()
        let loginData = LoginData(email: email, code: password)
        
        guard let postData = try? encoder.encode(loginData) else {
            fatalError("encoding error: \(loginData)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData as Data
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { [self] in try validate($0.data, $0.response)}
            .decode(type: Token.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HTTPError.statusCode
        }
        return data
    }
}
