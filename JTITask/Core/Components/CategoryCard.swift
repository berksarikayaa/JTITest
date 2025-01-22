import SwiftUI

struct CategoryCard: View {
    let category: ProductCategory
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                )
        }
    }
} 