import SwiftUI
import AVKit

struct ProductView360: View {
    let images: [UIImage]  // 360 derece görüntüler için
    @State private var currentAngle: Double = 0
    @State private var previousAngle: Double = 0
    @State private var isRotating = false
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: currentImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let delta = value.translation.width / geometry.size.width * 360
                            currentAngle = previousAngle + delta
                            updateImage()
                        }
                        .onEnded { _ in
                            previousAngle = currentAngle
                        }
                )
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            currentAngle = angle.degrees
                            updateImage()
                        }
                )
        }
    }
    
    private var currentImage: UIImage {
        let normalizedAngle = Int((currentAngle.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360))
        let index = Int(Double(normalizedAngle) / 360 * Double(images.count))
        return images[index]
    }
    
    private func updateImage() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
} 