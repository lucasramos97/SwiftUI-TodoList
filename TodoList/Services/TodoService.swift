//
//  TodoService.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import Foundation
import Combine

class TodoService {
    
    private let url_base = "http://localhost:4000/api/todos"
    
    @Published var todos: [Todo] = []
    private var todoSubscription: AnyCancellable?
    
    init() {
        getTodos()
    }
    
    func getTodos() {
        todoSubscription = NetworkingManger.download(url: URL(string: url_base)!)
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManger.handleCompletion, receiveValue: { [weak self] _todos in
                self?.todos = _todos
                self?.todoSubscription?.cancel()
            })
    }
    
    func postAndUpdateTodoList(_ todo: Todo) -> AnyPublisher<[Todo], Error> {
        return postTodo(todo)
                .flatMap { [weak self] _ in
                    return NetworkingManger.download(url: URL(string: self?.url_base ?? "")!)
                        .decode(type: [Todo].self, decoder: JSONDecoder())
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func updateAndUpdateTodoList(id: Int, todo: Todo) -> AnyPublisher<[Todo], Error> {
        return updateTodo(id: id, todo: todo)
                .flatMap { [weak self] _ in
                    return NetworkingManger.download(url: URL(string: self?.url_base ?? "")!)
                        .decode(type: [Todo].self, decoder: JSONDecoder())
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteAndUpdateTodoList(id: Int) -> AnyPublisher<[Todo], Error> {
        return deleteTodo(id: id)
                .flatMap { [weak self] _ in
                    return NetworkingManger.download(url: URL(string: self?.url_base ?? "")!)
                        .decode(type: [Todo].self, decoder: JSONDecoder())
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func postTodo(_ todo: Todo) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: URL(string: url_base)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(todo)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return NetworkingManger.upload(request: request)
    }
    
    private func updateTodo(id: Int, todo: Todo) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: URL(string: "\(url_base)/\(id)")!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(todo)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return NetworkingManger.upload(request: request)
    }
    
    private func deleteTodo(id: Int) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: URL(string: "\(url_base)/\(id)")!)
        request.httpMethod = "DELETE"
        
        return NetworkingManger.upload(request: request)
    }
}
