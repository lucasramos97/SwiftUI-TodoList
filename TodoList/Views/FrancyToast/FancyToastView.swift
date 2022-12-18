//
//  FancyToastView.swift
//  TodoList
//
//  Created by Lucas Ramos on 03/12/22.
//

import SwiftUI

struct FancyToastView: View {
    
    var message: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                
                VStack(alignment: .leading) {
                    Text("Error")
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                }
                Spacer(minLength: 10)
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(.red)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

struct FancyToastView_Previews: PreviewProvider {
  static var previews: some View {
      FancyToastView(message: "Error Here!")
  }
}
