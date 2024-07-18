//
//  NetworkManager.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit
import Foundation

class ResponseDecoder {
    static let shared = ResponseDecoder()
    
    func decode<T: Codable>(_ type: T.Type, from data: Data, completion: @escaping (Result<T, ErrorMessage>) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(T.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(.invalidData))
        }
    }
}

class UserService {
    private var authResponse: AuthResponse?
    
    func setAuthResponse(_ token: AuthResponse) {
        self.authResponse = token
    }
    
    func registerUser(username: String, password: String, email: String, name: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
        let payload = RegisterModel(username: username, password: password, email: email, name: name)
        
        guard let jsonData = try? JSONEncoder().encode(payload) else {
            completion(.failure(.invalidData))
            return
        }
        
        NetworkManager.shared.performRequest(endpoint: "api/user/register", method: "POST", payload: jsonData) { result in
            switch result {
            case .success(let data):
                ResponseDecoder.shared.decode(AuthResponse.self, from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
        let payload = LoginModel(username: username, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(payload) else {
            completion(.failure(.invalidData))
            return
        }
        
        NetworkManager.shared.performRequest(endpoint: "api/user/login", method: "POST", payload: jsonData) { result in
            switch result {
            case .success(let data):
                ResponseDecoder.shared.decode(AuthResponse.self, from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(completion: @escaping (Result<LogoutResponse, ErrorMessage>) -> Void) {
        NetworkManager.shared.performRequest(endpoint: "api/user/logout", method: "POST", authToken: authResponse) { result in
            switch result {
            case .success:
                completion(.success(LogoutResponse.init(success: true)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func listAllPosts(completion: @escaping (Result<[PostModel], ErrorMessage>) -> Void) {
        NetworkManager.shared.performRequest(endpoint: "api/post", method: "GET", authToken: authResponse) { result in
            switch result {
            case .success(let data):
                ResponseDecoder.shared.decode([PostModel].self, from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createPost(title: String, body: String, completion: @escaping (Result<CreatedPostModel, ErrorMessage>) -> Void) {
        let payload = CreatedPostModel(title: title, body: body)
        
        guard let jsonData = try? JSONEncoder().encode(payload) else {
            completion(.failure(.invalidData))
            return
        }
        
        NetworkManager.shared.performRequest(endpoint: "api/post", method: "POST", payload: jsonData, authToken: authResponse) { result in
            switch result {
            case .success(let data):
                ResponseDecoder.shared.decode(CreatedPostModel.self, from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func deletePost(withId id: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.performRequest(endpoint: "api/post/\(id)", method: "DELETE", authToken: authResponse) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://mobiletest.1902dev1.com/"
    private let secret  = "70a0389a-d701-4d78-a325-e7f5da2ae9b0"
    private let contentType = "application/json"
    
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func performRequest(endpoint: String, method: String, payload: Data? = nil, authToken: AuthResponse? = nil, completion: @escaping (Result<Data, ErrorMessage>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(secret, forHTTPHeaderField: "Secret")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let payload = payload {
            request.httpBody = payload
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                completion(.failure(.invalidData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let completeUrlString = "https://\(urlString)"
        
        guard let url = URL(string: completeUrlString) else {
            return nil
        }
        
        let cacheKey = NSString(string: urlString)
        
        // Check if image is already cached
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            cache.setObject(image, forKey: cacheKey)
            
            return image
        } catch {
            return nil
        }
    }
    
    //    func registerUser(username: String, password: String, email: String, name: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
    //        let registerUrl = "\(baseURL)/api/user/register"
    //
    //        let payload: [String: Any] = [
    //            "username": username,
    //            "password": password,
    //            "email": email,
    //            "name": name
    //        ]
    //
    //        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
    //            completion(.failure(.invalidJSON))
    //            return
    //        }
    //
    //        var request = URLRequest(url: URL(string: registerUrl)!)
    //        request.httpMethod = "POST"
    //        request.setValue(secret, forHTTPHeaderField: "Secret")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.httpBody = jsonData
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if let _ = error {
    //                completion(.failure(.unableToComplete))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(.invalidData))
    //                return
    //            }
    //
    //            do {
    //                let decoder = JSONDecoder()
    //                let registerResponse = try decoder.decode(AuthResponse.self, from: data)
    //                completion(.success(registerResponse))
    //            } catch {
    //                completion(.failure(.invalidData))
    //            }
    //        }.resume()
    //    }
    
    //    func loginUser(username: String, password: String, completion: @escaping (Result<AuthResponse, ErrorMessage>) -> Void) {
    //        let loginUrl = "\(baseURL)/api/user/login"
    //
    //        let payload: [String: Any] = [
    //            "username": username,
    //            "password": password
    //        ]
    //
    //        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
    //            completion(.failure(.invalidJSON))
    //            return
    //        }
    //
    //        guard let url = URL(string: loginUrl) else {
    //            completion(.failure(.invalidJSON))
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.setValue(secret, forHTTPHeaderField: "Secret")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.httpBody = jsonData
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if let _ = error {
    //                completion(.failure(.unableToComplete))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(.invalidData))
    //                return
    //            }
    //
    //            do {
    //                let decoder = JSONDecoder()
    //                let registerResponse = try decoder.decode(AuthResponse.self, from: data)
    //                completion(.success(registerResponse))
    //            } catch {
    //                completion(.failure(.invalidJSON))
    //            }
    //        }.resume()
    //    }
    
    //    func setAuthResponse(_ token: String) {
    //        self.authResponse = token
    //    }
    //
    //    func listAllPosts(completion: @escaping (Result<[PostModel], ErrorMessage>) -> Void) {
    //        let listPostsUrl = "\(baseURL)/api/post"
    //
    //        guard let url = URL(string: listPostsUrl) else {
    //            completion(.failure(.invalidURL))
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        request.setValue(secret, forHTTPHeaderField: "Secret")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        if let authToken = self.authResponse {
    //            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    //        }
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if error != nil {
    //                completion(.failure(.unableToComplete))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(.invalidData))
    //                return
    //            }
    //
    //            do {
    //                let decoder = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                let posts = try decoder.decode([PostModel].self, from: data)
    //                completion(.success(posts))
    //            } catch {
    //                completion(.failure(.invalidData))
    //            }
    //        }.resume()
    //    }
    
    //    func deletePost(withId id: String, completion: @escaping (Bool) -> Void) {
    //        let urlString = "\(baseURL)api/post/\(id)"
    //        guard let url = URL(string: urlString) else {
    //            completion(false)
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "DELETE"
    //        request.setValue(secret, forHTTPHeaderField: "Secret")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        request.setValue(self.authResponse, forHTTPHeaderField: "TOKEN")
    //
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            guard error == nil,
    //                  let response = response as? HTTPURLResponse,
    //                  response.statusCode == 200 else {
    //                completion(false)
    //                return
    //            }
    //            completion(true)
    //        }
    //        task.resume()
    //    }
}
