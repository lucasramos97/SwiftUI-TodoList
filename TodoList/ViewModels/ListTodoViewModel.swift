//
//  ListTodoViewModel.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import Foundation
import Combine

class ListTodoViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
    @Published var isLoading = false
    @Published var todoForm: Todo? = nil
    @Published var text = ""
    @Published var completed = false
    @Published var message: String? = nil
    
    private let todoService = TodoService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        isLoading = true
        addSubscribers()
    }
    
    func addTodo() {
        isLoading = true
        let todo = Todo(text: text, completed: completed)
        guard let todoForm = todoForm, let id = todoForm.id else {
            sinkData {
                todoService.postAndUpdateTodoList(todo)
            }
            return
        }
        sinkData {
            todoService.updateAndUpdateTodoList(id: id, todo: todo)
        }
    }
    
    func deleteTodo(indexSet: IndexSet) {
        isLoading = true
        let id = (indexSet.map { self.todos[$0].id }.first ?? 0) ?? 0
        sinkData {
            todoService.deleteAndUpdateTodoList(id: id)
        }
    }
    
    func prepareForm() {
        guard let todoForm = todoForm else {
            text = ""
            completed = false
            return
        }
        text = todoForm.text
        completed = todoForm.completed
    }
    
    private func addSubscribers() {
        todoService.$todos
            .sink { [weak self] _todos in
                self?.todos = _todos
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func sinkData(action: () -> AnyPublisher<[Todo], Error>) {
        action()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.message = error.localizedDescription
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] _todos in
                self?.todos = _todos
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
