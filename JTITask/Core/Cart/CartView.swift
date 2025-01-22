import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            VStack {
                if cartManager.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    List {
                        ForEach(cartManager.cartItems) { item in
                            CartItemRow(item: item)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                cartManager.removeItem(cartManager.cartItems[index])
                            }
                        }
                        
                        Section {
                            HStack {
                                Text(localizationManager.strings.total)
                                    .font(.headline)
                                Spacer()
                                Text(localizationManager.formatPrice(cartManager.total))
                                    .font(.headline)
                            }
                        }
                    }
                    
                    Button(action: {
                        // Ödeme işlemi
                    }) {
                        Text(localizationManager.strings.checkout)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle(localizationManager.strings.cart)
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @ObservedObject private var cartManager = CartManager.shared
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .font(.headline)
                Text(localizationManager.formatPrice(item.product.price))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button {
                    cartManager.decrementQuantity(for: item)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Text("\(item.quantity)")
                    .font(.headline)
                    .frame(minWidth: 30)
                
                Button {
                    cartManager.incrementQuantity(for: item)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct EmptyCartView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text(localizationManager.strings.emptyCart)
                .font(.title2)
            Text(localizationManager.strings.startShopping)
                .foregroundColor(.gray)
        }
    }
} 