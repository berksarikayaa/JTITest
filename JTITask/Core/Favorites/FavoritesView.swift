import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared // Favori yöneticisi
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favorites) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCard(product: product) // Favori ürün kartı
                    }
                }
            }
            .navigationTitle("Favoriler")
        }
    }
} 
