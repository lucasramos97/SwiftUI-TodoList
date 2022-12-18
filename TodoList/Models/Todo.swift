//
//  Todo.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import Foundation

struct Todo: Identifiable, Codable {
    
    let id: Int?
    let text: String
    let completed: Bool
    
    init(id: Int? = nil, text: String, completed: Bool) {
        self.id = id
        self.text = text
        self.completed = completed
    }
}
