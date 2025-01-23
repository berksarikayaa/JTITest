import Foundation
import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartManager: CartManager
    @Published var showCheckout = false
    
    init(cartManager: CartManager = .shared) {
        self.cartManager = cartManager
    }
    
    var items: [CartItem] {
        cartManager.items
    }
    
    var total: Double {
        cartManager.total
    }
    
    func increaseQuantity(for item: CartItem) {
        cartManager.increaseQuantity(for: item.product)
    }
    
    func decreaseQuantity(for item: CartItem) {
        cartManager.decreaseQuantity(for: item.product)
    }
    
    func removeItem(_ item: CartItem) {
        cartManager.removeFromCart(item.product)
    }
    
    func clearCart() {
        cartManager.clearCart()
    }
}
