import Foundation

class CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
} 
