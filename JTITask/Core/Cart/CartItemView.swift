import SwiftUI

struct CartItemView: View {
    let item: CartItem
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Ürün görseli ve bilgileri
            HStack(spacing: 12) {
                if let imageData = item.product.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Ürün bilgileri
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.product.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(item.product.nicotineStrength)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Fiyat
                    Text(localizationManager.formatPrice(item.product.price))
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Miktar kontrolleri
            HStack(spacing: 8) {
                // Azalt butonu
                Button {
                    cartManager.decreaseQuantity(for: item.product)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "minus")
                            .foregroundColor(.blue)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(item.quantity == 1)
                
                // Miktar
                Text("\(item.quantity)")
                    .font(.headline)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                
                // Artır butonu
                Button {
                    cartManager.increaseQuantity(for: item.product)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .frame(height: 44)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                cartManager.removeFromCart(item.product)
            } label: {
                Label("Sil", systemImage: "trash")
            }
        }
    }
} 
