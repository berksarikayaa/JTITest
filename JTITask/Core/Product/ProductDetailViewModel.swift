import Foundation
import SwiftUI
import os

/// Ürün detay ekranının view model'i
final class ProductDetailViewModel: ObservableObject {
    @Published private(set) var reviews: [ProductReview] = []
    @Published private(set) var similarProducts: [Product] = []
    @Published var quantity = 1
    @Published var selectedVariant: ProductVariant = .original
    @Published var showReviewSheet = false
    
    private let cartManager: CartManager
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ProductDetail")
    private let coreDataManager: CoreDataManager
    
    init(cartManager: CartManager = .shared, coreDataManager: CoreDataManager = .shared) {
        self.cartManager = cartManager
        self.coreDataManager = coreDataManager
        loadSimilarProducts()
        loadReviews()
    }
    
    /// Ürünü sepete ekler
    /// - Parameter product: Eklenecek ürün
    func addToCart(_ product: Product) {
        cartManager.addToCart(product, quantity: quantity)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Favorileri günceller
    /// - Parameter productId: Güncellenecek ürünün ID'si
    /// - Parameter completion: Güncellenmiş favori durumunu alacak closure
    func toggleFavorite(for productId: String, completion: @escaping (Bool) -> Void) {
        coreDataManager.toggleFavorite(for: productId) { updatedIsFavorite in
            DispatchQueue.main.async {
                completion(updatedIsFavorite)
                
                // Haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
    
    private func loadSimilarProducts() {
        // Burada gerçek API'dan benzer ürünler yüklenebilir
        // Şimdilik örnek veriler
        similarProducts = [
            // Örnek ürünler...
        ]
    }
    
    private func loadReviews() {
        // Gerçek uygulamada burada API'dan yorumlar yüklenebilir
        reviews = [
            ProductReview(
                userName: "Ahmet Y.",
                rating: 5,
                comment: "Harika bir ürün, çok memnun kaldım. Özellikle tadı ve kokusu çok güzel.",
                date: Date()
            ),
            ProductReview(
                userName: "Mehmet K.",
                rating: 4,
                comment: "Kaliteli bir ürün ama fiyatı biraz yüksek.",
                date: Date().addingTimeInterval(-86400)
            ),
            ProductReview(
                userName: "Ayşe S.",
                rating: 5,
                comment: "Tam beklediğim gibi, kesinlikle tavsiye ederim.",
                date: Date().addingTimeInterval(-172800)
            )
        ]
    }
    
    func loadSimilarProducts(for product: Product) {
        // Aynı kategorideki ürünleri getir
        let allProducts = CoreDataManager.shared.getAllProducts()
        similarProducts = allProducts
            .filter { $0.value(forKey: "category") as? String == product.category.rawValue }
            .prefix(5) // En fazla 5 ürün
            .compactMap { managedObject -> Product? in
                guard let name = managedObject.value(forKey: "name") as? String,
                      let desc = managedObject.value(forKey: "desc") as? String,
                      let price = managedObject.value(forKey: "price") as? Double,
                      let nicotineStrength = managedObject.value(forKey: "nicotineStrength") as? String,
                      let quantity = managedObject.value(forKey: "quantity") as? Int16,
                      let category = managedObject.value(forKey: "category") as? String,
                      let imageData = managedObject.value(forKey: "imageData") as? Data,
                      let categoryEnum = ProductCategory(rawValue: category) else {
                    return nil
                }
                
                return Product(
                    id: managedObject.value(forKey: "id") as? String ?? UUID().uuidString,
                    name: name,
                    description: desc,
                    price: price,
                    imageName: "",
                    category: categoryEnum,
                    nicotineStrength: nicotineStrength,
                    quantity: Int(quantity),
                    imageData: imageData
                )
            }
            .filter { $0.id != product.id } // Mevcut ürünü çıkar
    }
    
    func addReview(_ review: ProductReview) {
        withAnimation {
            reviews.insert(review, at: 0)
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Gerçek uygulamada burada API'ya yorum gönderilir
    }
    
    // Ortalama puanı hesapla
    var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(reviews.count)
    }
} 