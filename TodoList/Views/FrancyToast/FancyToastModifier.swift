//
//  FancyToastModifier.swift
//  TodoList
//
//  Created by Lucas Ramos on 03/12/22.
//

import SwiftUI

struct FancyToastModifier: ViewModifier {
    
    @Binding var message: String?
    
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView().offset(y: -30)
                }
                .animation(.spring(), value: message)
            )
            .onChange(of: message) { _ in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let message = message {
            VStack {
                Spacer()
                FancyToastView(message: message)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        if message == nil {
            return
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        workItem?.cancel()
        let task = DispatchWorkItem {
           dismissToast()
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }
    
    private func dismissToast() {
        withAnimation {
            message = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}
