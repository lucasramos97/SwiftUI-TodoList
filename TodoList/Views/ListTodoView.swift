//
//  ListTodoView.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import SwiftUI

struct ListTodoView: View {
    
    @EnvironmentObject private var listTodoViewModel: ListTodoViewModel
    @State private var showForm = false
    
    var body: some View {
        VStack {
            if listTodoViewModel.isLoading {
                ProgressView()
            } else {
                listTodo
            }
        }
        .navigationTitle("Todos")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                addButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $showForm) {
            TodoForm()
        }
        .toastView(message: $listTodoViewModel.message)
    }
}

struct ListTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListTodoView()
        }
        .environmentObject(ListTodoViewModel())
    }
}

extension ListTodoView {
    
    private var listTodo: some View {
        List {
            ForEach(listTodoViewModel.todos) { todo in
                todoRow(todo)
                    .onTapGesture {
                        listTodoViewModel.todoForm = todo
                        showForm = true
                    }
            }
            .onDelete(perform: listTodoViewModel.deleteTodo)
        }
        .listStyle(.plain)
    }
    
    private func todoRow(_ todo: Todo) -> some View {
        HStack {
            if todo.completed {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "x.circle")
                    .foregroundColor(.red)
            }
            Text(todo.text)
        }
    }
    
    private var addButton: some View {
        Button {
            listTodoViewModel.todoForm = nil
            showForm = true
        } label: {
            Text("Add")
        }
    }
}
