import SwiftUI

struct SimilarProductCard: View {
    let product: Product
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(isHovered ? 0.2 : 0.1),
                           radius: isHovered ? 10 : 5,
                           x: 0, y: isHovered ? 5 : 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text(product.nicotineStrength)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(localizationManager.formatPrice(product.price))
                    .font(.callout.bold())
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .frame(width: 120)
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
} 
