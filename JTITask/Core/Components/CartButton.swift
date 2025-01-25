import SwiftUI

struct CartButton: View {
    @ObservedObject private var cartManager = CartManager.shared
    @State private var isAnimating = false
    
    var body: some View {
        NavigationLink(destination: CartView()) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                
                if cartManager.itemCount > 0 {
                    Text("\(cartManager.itemCount)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onChange(of: cartManager.itemCount) { oldValue, newValue in
            if newValue > oldValue {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isAnimating = true
                }
                
                // Haptic feedback
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        isAnimating = false
                    }
                }
            }
        }
    }
} 