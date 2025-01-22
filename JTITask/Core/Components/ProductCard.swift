import SwiftUI

struct ProductCard: View {
    let product: Product
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(localizationManager.formatPrice(product.price))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Text(product.nicotineStrength)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
} 