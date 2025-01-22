import Foundation

class HomeViewModel: ObservableObject {
    @Published var featuredProducts: [Product] = []
    @Published var filteredProducts: [Product] = []
    
    init() {
        loadFeaturedProducts()
    }
    
    private func loadFeaturedProducts() {
        // Mevcut ürün yükleme kodu...
    }
    
    func searchProducts(query: String) {
        if query.isEmpty {
            filteredProducts = featuredProducts
        } else {
            filteredProducts = featuredProducts.filter { product in
                product.name.lowercased().contains(query.lowercased()) ||
                product.description.lowercased().contains(query.lowercased()) ||
                product.nicotineStrength.lowercased().contains(query.lowercased())
            }
        }
    }
} 