import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if viewModel.favoriteProducts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Henüz favori ürününüz yok")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(viewModel.favoriteProducts) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                ProductCard(product: product)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favoriler")
    }
}

#Preview {
    FavoritesView()
        .environmentObject(LocalizationManager())
} 
