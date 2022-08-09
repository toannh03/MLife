//
//  APIClient.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 06/08/2022.
//

import Foundation


class APIClient {
    
    // singletion
    static let shared = APIClient()
    
    private init() {}
    
    struct Constant {
        static let baseURL = "https://yomusic-api.herokuapp.com/api"
    }
    
    // Error handling
    enum APIError: Error {
        case failureToGetData
    }
    
    private func createRequest(url: URL?, method: HTTPMethod, completionHandler: @escaping(URLRequest) -> Void) {
        
        guard let url = url else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        completionHandler(request)

    }
    
    func getTopics(completion: @escaping (Result<[TopicResponse], Error>) -> Void) {
        
        createRequest(url: URL(string: Constant.baseURL + "/getCategoryForTopic/"), method: .GET) { URLRequest in
            
            URLSession.shared.dataTask(with: URLRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failureToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode([TopicResponse].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.failureToGetData))
                }
                
            }.resume()
        }
    }
    
    func getSongInAlbum(completion: @escaping (Result<[AlbumResponse], Error>) -> Void) {
        
        createRequest(url: URL(string: Constant.baseURL + "/getAllSongInAlbum/"), method: .GET) { URLRequest in
            
            URLSession.shared.dataTask(with: URLRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failureToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode([AlbumResponse].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.failureToGetData))
                }
                
            }.resume()
            
        }
    }
    
    func getSongInTrending(completion: @escaping (Result<[TredingResponse], Error>) -> Void) {
        
        createRequest(url: URL(string: Constant.baseURL + "/getSongInTrending/"), method: .GET) { URLRequest in
            
            URLSession.shared.dataTask(with: URLRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failureToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([TredingResponse].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.failureToGetData))
                }

            }.resume()
        }
        
    }
    
    func getSongInPlayList(completion: @escaping (Result<[PlayListResponse], Error>) -> Void) {
        
        createRequest(url: URL(string: Constant.baseURL + "/getSongPlayList/"), method: .GET) { URLRequest in
            
            URLSession.shared.dataTask(with: URLRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failureToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([PlayListResponse].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.failureToGetData))
                }
                
            }.resume()
        }
        
    }
    
    func getMostLikeSong(completion: @escaping (Result<[Song], Error>) -> Void) {
        
        createRequest(url: URL(string: Constant.baseURL + "/getMostLikeSong?limit=6"), method: .GET) { URLRequest in
            
            URLSession.shared.dataTask(with: URLRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failureToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([Song].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.failureToGetData))
                }
                
            }.resume()
        }
        
    }
    
}
