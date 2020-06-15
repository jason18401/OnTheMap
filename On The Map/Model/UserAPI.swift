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
    
    func postUserRequest(firstName: String, lastName: String, mediaUrl: String, location: String, lat: Double, long: Double, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Endpoint.userSession.rawValue)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let userKey = UserAPI.userKey else {
            print("NO USERKEY FOUND DURING POST")
            return
        }
        
        let body = "{\"uniqueKey\": \"\(userKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaUrl)\", \"latitude\": \(lat), \"longitude\": \(long)}".data(using: .utf8)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { completionHandler(.failure(error!)); return }
                
//                let range = 5..<data.count
//                let newData = data.subdata(in: range) /* subset response data! */
//                print("USER POST SUCCESS: \(String(data: newData, encoding: .utf8)!)")
                print("USER POST SUCCESS: \(String(data: data, encoding: .utf8)!)")
                completionHandler(.success(true))
            }
            task.resume()
        } catch {
            completionHandler(.failure(error))
        }
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
                
                //decode to get account key
                let decoder = JSONDecoder()
                
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: newData)
                    print("RES: \(String(describing: loginResponse))")
                    UserAPI.userKey = loginResponse.account.key
                    print("USERKEY: \(String(describing: UserAPI.userKey))")

                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            completionHandler(.success(loginResponse))
                        }
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func logoutRequest(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Endpoint.userSession.rawValue)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(.failure(error!))
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completionHandler(.success(true))
        }
        task.resume()
    }

}
