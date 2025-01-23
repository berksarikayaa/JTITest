import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            TextField("Ürün ara...", text: $text)
                .focused($isFocused)
                .font(.system(size: 16))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button {
                    withAnimation {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
} 
