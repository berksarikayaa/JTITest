import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            NavigationView {
                Group {
                    if cartManager.items.isEmpty {
                        EmptyCartView()
                            .background(.clear)
                    } else {
                        List {
                            ForEach(cartManager.items) { item in
                                CartItemView(item: item)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                cartManager.removeFromCart(item.product)
                                            }
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                            }
                            
                            Section {
                                HStack {
                                    Text(localizationManager.strings.total)
                                        .font(.headline)
                                    Spacer()
                                    Text(localizationManager.formatPrice(cartManager.total))
                                        .font(.title3.bold())
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle(localizationManager.strings.cart)
                .toolbar {
                    if !cartManager.items.isEmpty {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(localizationManager.strings.checkout) {
                                viewModel.showCheckout = true
                            }
                        }
                    }
                }
            }
        }
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
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.clear)
    }
} 