import Foundation

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var selectedCategory: ProductCategory?
    @Published var searchText = ""
    
    init() {
        // Örnek ürünler
        products = [
            Product(
                id: "1",
                name: "Nordic Spirit Mint",
                description: "Ferahlatıcı nane aromalı nikotin poşeti. Uzun süren tazelik hissi ve dengeli nikotin salınımı sağlar.",
                price: 149.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_MINT_MINI_1024x1024.png",
                category: .nordic,
                nicotineStrength: "9mg/poşet",
                quantity: 20
            ),
            Product(
                id: "2",
                name: "Nordic Spirit Bergamot Wildberry",
                description: "Bergamot ve yaban mersini aromalı nikotin poşeti. Eşsiz tat kombinasyonu ile benzersiz bir deneyim sunar.",
                price: 159.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_BERGAMOT_WILDBERRY_1024x1024.png",
                category: .nordic,
                nicotineStrength: "12mg/poşet",
                quantity: 20
            ),
            Product(
                id: "3",
                name: "Original Strong",
                description: "Klasik tütün aromalı güçlü nikotin poşeti. Geleneksel tat arayanlar için ideal seçim.",
                price: 139.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_ORIGINAL_1024x1024.png",
                category: .original,
                nicotineStrength: "14mg/poşet",
                quantity: 20
            ),
            Product(
                id: "4",
                name: "Smooth Mint",
                description: "Yumuşak nane aromalı nikotin poşeti. Hafif içim arayanlar için özel olarak tasarlandı.",
                price: 144.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_SMOOTH_MINT_1024x1024.png",
                category: .smooth,
                nicotineStrength: "6mg/poşet",
                quantity: 20
            ),
            Product(
                id: "5",
                name: "Nordic Spirit Elderflower",
                description: "Mürver çiçeği aromalı nikotin poşeti. Çiçeksi ve zarif aromasıyla farklı bir deneyim sunar.",
                price: 154.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_ELDERFLOWER_1024x1024.png",
                category: .nordic,
                nicotineStrength: "9mg/poşet",
                quantity: 20
            ),
            Product(
                id: "6",
                name: "Original Classic",
                description: "Klasik tütün aromalı standart nikotin poşeti. Dengeli içim arayanlar için uygun seçenek.",
                price: 134.90,
                imageURL: "https://nordicspirit.co.uk/cdn/shop/products/NS_ORIGINAL_CLASSIC_1024x1024.png",
                category: .original,
                nicotineStrength: "10mg/poşet",
                quantity: 20
            )
        ]
        
        filteredProducts = products
    }
    
    func fetchProducts(category: ProductCategory? = nil) {
        isLoading = true
        // Gerçek API çağrısı yerine kategoriye göre filtreleme
        if let category = category {
            filteredProducts = products.filter { $0.category == category }
        } else {
            filteredProducts = products
        }
        isLoading = false
    }
    
    func filterProducts(by category: ProductCategory?) {
        selectedCategory = category
        fetchProducts(category: category)
    }
    
    func searchProducts() {
        if searchText.isEmpty {
            filteredProducts = selectedCategory == nil ? products : products.filter { $0.category == selectedCategory }
        } else {
            let filtered = products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText)
            }
            filteredProducts = selectedCategory == nil ? filtered : filtered.filter { $0.category == selectedCategory }
        }
    }
} 