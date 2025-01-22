import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductDetailViewModel()
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Ürün görseli
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Ürün bilgileri
                    Text(product.name)
                        .font(.title)
                        .bold()
                    
                    Text(localizationManager.formatPrice(product.price))
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("Nikotin Oranı: \(product.nicotineStrength)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text("Ürün Açıklaması")
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addToFavorites(product)
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AddToCartButton(viewModel: viewModel, product: product)
        }
        .background(Color(colorScheme == .dark ? .black : .white).ignoresSafeArea())
    }
}

struct AddToCartButton: View {
    @ObservedObject var viewModel: ProductDetailViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    let product: Product
    
    var body: some View {
        VStack {
            HStack {
                Stepper("\(localizationManager.strings.quantity): \(viewModel.quantity)", value: $viewModel.quantity, in: 1...10)
                    .fixedSize()
                
                Spacer()
                
                Button {
                    viewModel.addToCart(product)
                } label: {
                    Text(localizationManager.strings.addToCart)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 44)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .shadow(radius: 2)
        }
    }
} 