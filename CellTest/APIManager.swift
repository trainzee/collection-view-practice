//
//  APIManager.swift
//  CellTest
//
//  Created by Dmitry on 30.03.2023.
//

import Foundation

class NetworkingManager {
    
    enum Result<T, U: Error> {
        case success(T)
        case fail(U)
    }
    
    enum ResponseError: Error {
        case network
        case decoding
        
        var reason: String {
            switch self {
            case .network:
                return("Error occurred while fetching data")
            case .decoding:
                return("Error occured while encoding data")
            }
        }
    }
    
    var runningRequests = [UUID: URLSessionDataTask]()
    
    static let shared = NetworkingManager()
    
    let url = "https://api.unsplash.com/search/photos/?query=gothic&client_id=Njwk9mCwCt9TabED1YemFimxTRb8H8TekIIOClVLxQQ&per_page=50"
    func fetchImageData(page: Int, withCompletion completion: @escaping (Result<ImageList, ResponseError>) -> Void) -> UUID?{
        let url = URL(string: "https://api.unsplash.com/search/photos/?query=gothic&client_id=Njwk9mCwCt9TabED1YemFimxTRb8H8TekIIOClVLxQQ&per_page=50&page=\(page)")!
        print("fetchImageData")
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            guard
                let properResoponse = response as? HTTPURLResponse,
                let data = data
            else {
                completion(Result.fail(ResponseError.network))
                return
            }
            
            guard let decodeImageList = try? JSONDecoder().decode(ImageList.self, from: data) else {
                completion(Result.fail(ResponseError.decoding))
                return
            }
            completion(Result.success(decodeImageList))
        })
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancellFetch(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
