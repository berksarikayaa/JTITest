import Foundation

// CartItem modelini tek bir yerde tanımlıyoruz
struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
} 
