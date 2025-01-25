import SwiftUI

struct ProductImageView: View {
    let imageData: Data?
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var showFullScreen = false
    
    var body: some View {
        ZStack {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(imageScale)
                    .offset(imageOffset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                imageScale = value
                            }
                            .onEnded { _ in
                                withAnimation {
                                    imageScale = 1.0
                                    imageOffset = .zero
                                }
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if imageScale > 1 {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    imageOffset = .zero
                                }
                            }
                    )
                    .onTapGesture(count: 2) {
                        withAnimation {
                            imageScale = imageScale > 1 ? 1 : 2
                        }
                    }
                    .onTapGesture {
                        showFullScreen = true
                    }
            } else {
                Color.gray.opacity(0.3)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenImageView(imageData: imageData)
        }
    }
}

#Preview {
    ProductImageView(imageData: nil)
} 