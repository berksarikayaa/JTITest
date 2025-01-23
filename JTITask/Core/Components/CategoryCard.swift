import SwiftUI

struct CategoryCard: View {
    let category: ProductCategory?
    let isSelected: Bool
    let action: () -> Void
    
    var categoryName: String {
        category?.rawValue ?? "Tümü"
    }
    
    var categoryColor: Color {
        if let category = category {
            switch category {
            case .original: return .blue
            case .nordic: return .purple
            case .smooth: return .green
            }
        }
        return .gray
    }
    
    var categoryIcon: String {
        if let category = category {
            switch category {
            case .original: return "leaf.fill"
            case .nordic: return "snowflake"
            case .smooth: return "wind"
            }
        }
        return "square.grid.2x2.fill"
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(categoryColor.opacity(isSelected ? 0.3 : 0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: categoryIcon)
                            .font(.title2)
                            .foregroundColor(isSelected ? categoryColor : .gray)
                    )
                
                Text(categoryName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .frame(width: 100)
            .padding(.vertical, 12)
            .background(isSelected ? categoryColor.opacity(0.1) : Color.clear)
            .cornerRadius(12)
        }
    }
} 
