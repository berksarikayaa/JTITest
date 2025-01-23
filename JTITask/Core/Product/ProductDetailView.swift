import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductDetailViewModel()
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showFullScreenImage = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Ürün görseli
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        showFullScreenImage = true
                    }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Ürün başlığı ve fiyat
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.name)
                                .font(.title2.bold())
                            
                            Text(localizationManager.formatPrice(product.price))
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.addToFavorites(product)
                        } label: {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(viewModel.isFavorite ? .red : .gray)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Özellikler
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "tag.fill", title: "Kategori", value: product.category.rawValue)
                        FeatureRow(icon: "drop.fill", title: "Nikotin", value: product.nicotineStrength)
                        FeatureRow(icon: "number", title: "Adet", value: "\(product.quantity) poşet")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Açıklama
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ürün Açıklaması")
                            .font(.headline)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Benzer Ürünler
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Benzer Ürünler")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.similarProducts) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        SimilarProductCard(product: product)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            AddToCartButton(viewModel: viewModel, product: product)
        }
        .background(Color(colorScheme == .dark ? .black : .white).ignoresSafeArea())
        .fullScreenCover(isPresented: $showFullScreenImage) {
            FullScreenImageView(imageName: product.imageName)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .bold()
        }
    }
}

struct SimilarProductCard: View {
    let product: Product
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(product.name)
                .font(.caption)
                .lineLimit(2)
            
            Text(localizationManager.formatPrice(product.price))
                .font(.caption.bold())
                .foregroundColor(.blue)
        }
        .frame(width: 120)
    }
}

struct FullScreenImageView: View {
    let imageName: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
        }
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