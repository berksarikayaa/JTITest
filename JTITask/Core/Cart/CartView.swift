import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(colorScheme == .dark ? .black : .white)
                    .ignoresSafeArea()
                
                if cartManager.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(cartManager.cartItems) { item in
                                    CartItemRow(item: item)
                                        .transition(.slide)
                                }
                            }
                            .padding()
                        }
                        
                        CartSummaryView(total: cartManager.total)
                    }
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
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Silme butonu arka planda
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        cartManager.removeItem(item)
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                }
                .background(Color.red)
                .cornerRadius(12)
            }
            
            // Ürün kartı
            HStack(spacing: 12) {
                Image(item.product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.product.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(item.product.nicotineStrength)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(localizationManager.formatPrice(item.product.price))
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                // Miktar kontrolleri
                VStack(spacing: 8) {
                    Button {
                        withAnimation {
                            cartManager.incrementQuantity(for: item)
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(item.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button {
                        withAnimation {
                            cartManager.decrementQuantity(for: item)
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = max(value.translation.width, -60)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -50 {
                                offset = -60
                            } else {
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
}

struct CartSummaryView: View {
    let total: Double
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("Ara Toplam")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(localizationManager.formatPrice(total))
                        .bold()
                }
                
                HStack {
                    Text("Kargo")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Ücretsiz")
                        .foregroundColor(.green)
                        .bold()
                }
                
                Divider()
                
                HStack {
                    Text(localizationManager.strings.total)
                        .font(.headline)
                    Spacer()
                    Text(localizationManager.formatPrice(total))
                        .font(.title3.bold())
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            Button {
                // Ödeme işlemi
            } label: {
                Text(localizationManager.strings.checkout)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
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