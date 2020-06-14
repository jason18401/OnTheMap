//
//  UserAPI.swift
//  On The Map
//
//  Created by Jason Yu on 6/10/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation

struct UserAPI {
    static let shared = UserAPI()
    static var userKey: String? = ""
    
    enum Endpoint: String {
        case userEndpointLimit100OrderUpdated = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        case userEndpointLimit100 = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100"
        case userEndpointPost = "https://onthemap-api.udacity.com/v1/StudentLocation"
        case userSession = "https://onthemap-api.udacity.com/v1/session"
        
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    func requestUserList(completionHandler: @escaping (Result<UserResponse, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoint.userEndpointLimit100OrderUpdated.url) { (data, response, error) in
            guard let data = data else { completionHandler(.failure(error!)); return }
            let decoder = JSONDecoder()
            do {
                let usersResponse = try decoder.decode(UserResponse.self, from: data)
                print("RES: \(String(describing: usersResponse.results.first?.firstName))")
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completionHandler(.success(usersResponse))
                    }
                }
            }
            catch {
                print("Error Paring usersRes: \(error)")
                completionHandler(.failure(error))
            }

        }
        task.resume()
    }
    
    func loginRequest(email: String, password: String, completionHandler: @escaping (Result<LoginResponse, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Endpoint.userSession.rawValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = UdacityLogin(username: email, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(LoginRequest(udacity: body))
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { completionHandler(.failure(error!)); return }
                
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                print("LOGINREQUEST:: \(String(describing: response))")
                
                //decode to get account key
                let decoder = JSONDecoder()
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                    print("RES: \(String(describing: loginResponse))")
                    UserAPI.userKey = loginResponse.account.key
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            completionHandler(.success(loginResponse))
                        }
                    }
                } catch {
                    print("Error Paring loginResponse: \(error)")
                    completionHandler(.failure(error))

                }
                
            }
            task.resume()
        } catch {
            print(error)
            completionHandler(.failure(error))
        }
    }
    
//    func loginRequest(email: String, password: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//        var request = URLRequest(url: URL(string: Endpoint.userSession.rawValue)!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = UdacityLogin(username: email, password: password)
//
//        do {
//            request.httpBody = try JSONEncoder().encode(LoginRequest(udacity: body))
//
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard let data = data else { completionHandler(.failure(error!)); return }
//
//                let range = 5..<data.count
//                let newData = data.subdata(in: range) /* subset response data! */
//                print(String(data: newData, encoding: .utf8)!)
//                print("LOGINREQUEST:: \(String(describing: response))")
//
//                //decode to get account key and session
//                let decoder = JSONDecoder()
//
//
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        completionHandler(.success(true))
//                    }
//                }
//            }
//            task.resume()
//        } catch {
//            print(error)
//            completionHandler(.failure(error))
//        }
//    }
}
