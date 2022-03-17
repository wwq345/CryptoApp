//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/17.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetWorkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unKnown
        
        var errorDescription: String?{
            switch self {
            case .badURLResponse(url: let url):
                return "Bad response from URL:\(url)"
            case .unKnown:
                return "Uknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode <= 300 else{
                  throw NetWorkingError.badURLResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
