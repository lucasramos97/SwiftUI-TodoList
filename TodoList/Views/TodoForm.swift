//
//  TodoForm.swift
//  TodoList
//
//  Created by Lucas Ramos on 26/11/22.
//

import SwiftUI

struct TodoForm: View {
    
    @EnvironmentObject private var listTodoViewModel: ListTodoViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                inputText
                completedToggle
                addButton
                Spacer()
            }
            .navigationTitle("Add Todo")
            .toolbar {
                ToolbarItem {
                    closeButton
                }
            }
            .onAppear {
                listTodoViewModel.prepareForm()
            }
        }
    }
}

struct TodoForm_Previews: PreviewProvider {
    static var previews: some View {
        TodoForm()
            .environmentObject(ListTodoViewModel())
    }
}

extension TodoForm {
    
    private var inputText: some View {
        TextField("Text...", text: $listTodoViewModel.text)
            .padding(.horizontal)
            .frame(height: 55)
            .background(Color.gray.opacity(0.7).cornerRadius(10))
            .padding(.horizontal)
    }
    
    private var completedToggle: some View {
        Toggle("Completed: ", isOn: $listTodoViewModel.completed)
            .padding(.horizontal)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .frame(width: 180)
    }
    
    private var addButton: some View {
        Button {
            listTodoViewModel.addTodo()
            dismiss()
        } label: {
            Text("Add")
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.cornerRadius(10))
                .padding(.horizontal)
        }
        .disabled(disableButton)
    }
    
    private var disableButton: Bool {
        return listTodoViewModel.text.isEmpty || listTodoViewModel.text.count < 3
    }
    
    private var closeButton: some View {
        Image(systemName: "xmark")
            .font(.title)
            .onTapGesture {
                dismiss()
            }
    }
}
