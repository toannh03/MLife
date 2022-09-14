//
//  APISearch.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 10/08/2022.
//

import Foundation

struct Json: Encodable {
    let name_song: String
}

class APISearch {
    
    static let shared = APISearch()
    
    private init() {}
    
    func searchResults(with query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        
        guard let url = URL(string: Config.baseURL + "/searchByKeywords" ) else { return }
        
        var request = URLRequest(url: url)
                
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                
        do {
            // Convert parameters to Data and assign encrypted data to httpBody of request
            let data = Json(name_song: query)
            let sData = try JSONEncoder().encode(data)
            request.httpBody = sData
            
        } catch let error {
            
            print(error.localizedDescription)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                return 
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            // Check if the call is successful
            guard 200 ... 299 ~= statusCode else {
                
                completion(.failure(APIError.failureToGetData))
                print("Error with the response, unexpected status code")
                return
                
            }
            
            // Decode song result
            do {
                let result =  try JSONDecoder().decode([Song].self, from: data)
                completion(.success(result))
            } catch {
                print(error.localizedDescription)
                completion(.failure(APIError.failureToGetData))
            }
            
        }.resume()
        
    }
    
    
    
}
