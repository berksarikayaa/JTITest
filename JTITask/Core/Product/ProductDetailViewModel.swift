import Foundation
import SwiftUI

class ProductDetailViewModel: ObservableObject {
    @Published var quantity = 1
    @Published var isFavorite = false
    @Published var selectedVariant: ProductVariant = .original
    @Published var reviews: [ProductReview] = []
    @Published var showReviewSheet = false
    @Published var similarProducts: [Product] = []
    private let cartManager = CartManager.shared
    
    init() {
        loadSimilarProducts()
        loadReviews()
    }
    
    func addToCart(_ product: Product) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            cartManager.addToCart(product, quantity: quantity)
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func toggleFavorite(for product: inout Product) {
        product.isFavorite.toggle()
        isFavorite = product.isFavorite
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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