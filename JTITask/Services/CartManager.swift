import Foundation
import SwiftUI

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var items: [String: CartItem] = [:] // product.id -> CartItem
    
    var cartItems: [CartItem] {
        Array(items.values)
    }
    
    var total: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var itemCount: Int {
        items.count
    }
    
    private init() {}
    
    func addToCart(_ product: Product, quantity: Int) {
        if let existingItem = items[product.id] {
            existingItem.quantity += quantity
            objectWillChange.send()
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items[product.id] = newItem
        }
    }
    
    func removeItem(_ item: CartItem) {
        items.removeValue(forKey: item.product.id)
        objectWillChange.send()
    }
    
    func incrementQuantity(for item: CartItem) {
        guard let existingItem = items[item.product.id] else { return }
        existingItem.quantity += 1
        objectWillChange.send()
    }
    
    func decrementQuantity(for item: CartItem) {
        guard let existingItem = items[item.product.id] else { return }
        if existingItem.quantity > 1 {
            existingItem.quantity -= 1
            objectWillChange.send()
        }
    }
} 