import Foundation

class CartViewModel: ObservableObject {
    @Published var cartManager: CartManager
    
    init(cartManager: CartManager = .shared) {
        self.cartManager = cartManager
    }
    
    var cartItems: [CartItem] {
        cartManager.cartItems
    }
    
    var total: Double {
        cartManager.total
    }
    
    func updateQuantity(for item: CartItem, increment: Bool) {
        if increment {
            cartManager.incrementQuantity(for: item)
        } else {
            cartManager.decrementQuantity(for: item)
        }
    }
    
    func removeItem(_ item: CartItem) {
        cartManager.removeItem(item)
    }
}
