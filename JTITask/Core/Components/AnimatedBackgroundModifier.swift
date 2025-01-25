import SwiftUI

struct AnimatedBackground: View {
    @State private var offset: CGFloat = 0
    
    private let gradientColors: [Color] = [
        Color(hex: "134E5E"),  // Koyu deniz mavisi
        Color(hex: "71B280"),  // Yumuşak yeşil
        Color(hex: "2193b0"),  // Parlak mavi
        Color(hex: "6dd5ed")   // Açık mavi
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                
                ZStack {
                    // Gradient arka plan
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.07)
                    
                    // Animasyonlu şekiller
                    ForEach(0..<15) { index in
                        Circle()
                            .fill(gradientColors[index % gradientColors.count])
                            .opacity(0.05)
                            .frame(
                                width: CGFloat.random(in: 30...120),
                                height: CGFloat.random(in: 30...120)
                            )
                            .offset(
                                x: CGFloat.random(in: -geometry.size.width/2...geometry.size.width/2),
                                y: CGFloat.random(in: -geometry.size.height/2...geometry.size.height/2)
                            )
                            .offset(y: minY * 0.3)
                            .blur(radius: 5)
                            .animation(
                                .easeInOut(duration: 3)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.1),
                                value: minY
                            )
                    }
                }
                .frame(height: geometry.size.height + abs(minY))
                .offset(y: minY > 0 ? -minY : 0)
            }
        }
        .ignoresSafeArea()
    }
} 