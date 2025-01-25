import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favorites: [Product] = []
    
    func addFavorite(_ product: Product) {
        if !favorites.contains(where: { $0.id == product.id }) {
            favorites.append(product)
        }
    }
    
    func removeFavorite(_ product: Product) {
        favorites.removeAll { $0.id == product.id }
    }
} 