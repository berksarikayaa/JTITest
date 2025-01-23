import Foundation
import SwiftUI

class ProductDetailViewModel: ObservableObject {
    @Published var quantity = 1
    @Published var isFavorite = false
    @Published var similarProducts: [Product] = []
    private let cartManager = CartManager.shared
    
    init() {
        loadSimilarProducts()
    }
    
    func addToCart(_ product: Product) {
        withAnimation {
            cartManager.addToCart(product, quantity: quantity)
            quantity = 1
        }
    }
    
    func addToFavorites(_ product: Product) {
        withAnimation(.spring()) {
            isFavorite.toggle()
        }
    }
    
    private func loadSimilarProducts() {
        // Burada gerçek API'dan benzer ürünler yüklenebilir
        // Şimdilik örnek veriler
        similarProducts = [
            // Örnek ürünler...
        ]
    }
} 