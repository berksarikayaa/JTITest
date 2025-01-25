import SwiftUI

struct AddToCartAnimationModifier: ViewModifier {
    let sourcePoint: CGPoint
    let destinationPoint: CGPoint
    @Binding var isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isAnimating {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .position(sourcePoint)
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .opacity
                            ))
                            .animation(
                                .spring(
                                    response: 0.6,
                                    dampingFraction: 0.8,
                                    blendDuration: 0.8
                                ),
                                value: isAnimating
                            )
                    }
                }
            )
    }
}

extension View {
    func addToCartAnimation(
        from source: CGPoint,
        to destination: CGPoint,
        isAnimating: Binding<Bool>
    ) -> some View {
        self.modifier(
            AddToCartAnimationModifier(
                sourcePoint: source,
                destinationPoint: destination,
                isAnimating: isAnimating
            )
        )
    }
} 