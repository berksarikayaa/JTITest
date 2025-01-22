import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var quantity = 1
    @Published var isFavorite = false
    private let cartManager = CartManager.shared
    
    func addToCart(_ product: Product) {
        cartManager.addToCart(product, quantity: quantity)
        quantity = 1 // Sıfırla
    }
    
    func addToFavorites(_ product: Product) {
        isFavorite.toggle()
    }
} 