import Foundation
import SwiftUI

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var items: [CartItem] = []
    
    var total: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var itemCount: Int {
        items.count
    }
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            var updatedItems = items
            updatedItems[index].quantity += quantity
            items = updatedItems
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeFromCart(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
    }
    
    func increaseQuantity(for product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            var updatedItems = items
            updatedItems[index].quantity += 1
            items = updatedItems
        }
    }
    
    func decreaseQuantity(for product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if items[index].quantity > 1 {
                var updatedItems = items
                updatedItems[index].quantity -= 1
                items = updatedItems
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
} 