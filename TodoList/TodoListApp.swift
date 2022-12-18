//
//  TodoListApp.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import SwiftUI

@main
struct TodoListApp: App {
    
    @StateObject private var listTodoViewModel = ListTodoViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListTodoView()
            }
            .environmentObject(listTodoViewModel)
        }
    }
}
