//
//  NetworkingManger.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import Foundation
import Combine

struct NetworkingManger {
    
    enum NetworkingError: LocalizedError {
        case responseContent(message: String)
        case responseFormat
        
        var errorDescription: String? {
            switch self {
            case .responseContent(let message):
                return message
            case .responseFormat:
                return "Response is not a HTTPURLResponse!"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
    
    static func upload(request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ try handleURLResponse(output: $0, url: request.url!) })
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            break
        }
    }
    
    private static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else { throw NetworkingError.responseFormat }
        if response.statusCode == 412 {
            throw NetworkingError.responseContent(message: getMessage(data: output.data))
        }
        
        return output.data
    }
    
    private static func getMessage(data: Data) -> String {
        let defaultMessage = "Message not Found!"
        do {
            guard
                let body = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            else {
                return defaultMessage
            }
            
            return body["message"] ?? defaultMessage
        } catch {
            return defaultMessage
        }
    }
}
