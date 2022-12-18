//
//  View.swift
//  TodoList
//
//  Created by Lucas Ramos on 03/12/22.
//

import Foundation
import SwiftUI

extension View {
    func toastView(message: Binding<String?>) -> some View {
        self.modifier(FancyToastModifier(message: message))
    }
}

