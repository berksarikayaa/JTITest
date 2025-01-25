import SwiftUI
import CoreData

struct ProductCard: View {
    @State var product: Product
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var localizationManager: LocalizationManager
    @StateObject private var viewModel = ProductDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // Ürün görseli
                if let imageData = product.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // Favori butonu
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.toggleFavorite(for: product.id) { updatedIsFavorite in
                            product.isFavorite = updatedIsFavorite
                        }
                    }
                } label: {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(product.isFavorite ? .red : .gray)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.8)))
                        .shadow(radius: 2)
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(localizationManager.formatPrice(product.price))
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(product.nicotineStrength)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding(12)
        }
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
} 