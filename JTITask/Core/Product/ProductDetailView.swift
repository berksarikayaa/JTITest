import SwiftUI
import AVKit

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductDetailViewModel()
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showFullScreenImage = false
    @State private var showAddedToCartAlert = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var selectedTab = 0
    @State private var isAddToCartAnimating = false
    @State private var productImagePosition: CGPoint = .zero
    @State private var cartButtonPosition: CGPoint = .zero
    @State private var showAddReview = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Ürün görseli ve 360 görüntüleme
                    TabView(selection: $selectedTab) {
                        // Normal görsel
                        ProductImageView(imageData: product.imageData)
                            .tag(0)
                        
                        // 360 görüntüleme (opsiyonel)
                        if let images360 = product.images360, !images360.isEmpty {
                            ProductView360(images: images360)
                                .tag(1)
                        }
                        
                        // Ürün videosu (opsiyonel)
                        if let videoURL = product.videoURL {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .tag(2)
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 300)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: ViewPositionKey.self,
                            value: geometry.frame(in: .global).center
                        )
                    })
                    
                    // Tab göstergeleri
                    HStack {
                        Circle()
                            .fill(selectedTab == 0 ? Color.blue : Color.gray)
                            .frame(width: 8, height: 8)
                        if let images360 = product.images360, !images360.isEmpty {
                            Circle()
                                .fill(selectedTab == 1 ? Color.blue : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                        if product.videoURL != nil {
                            Circle()
                                .fill(selectedTab == 2 ? Color.blue : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Ürün başlığı ve fiyat
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(product.name)
                                    .font(.title2.bold())
                                
                                Text(localizationManager.formatPrice(product.price))
                                    .font(.title.bold())
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.addToFavorites(product)
                            } label: {
                                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(viewModel.isFavorite ? .red : .gray)
                                    .frame(width: 44, height: 44)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Varyant seçimi
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ProductVariant.allCases, id: \.self) { variant in
                                    VariantButton(
                                        variant: variant,
                                        isSelected: viewModel.selectedVariant == variant,
                                        action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                viewModel.selectedVariant = variant
                                            }
                                            // Haptic feedback
                                            let generator = UISelectionFeedbackGenerator()
                                            generator.selectionChanged()
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        // Ürün özellikleri tablosu
                        ProductSpecsTable(product: product)
                            .padding(.horizontal)
                        
                        // Açıklama
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ürün Açıklaması")
                                .font(.headline)
                            
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Benzer Ürünler
                        if !viewModel.similarProducts.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Benzer Ürünler")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.similarProducts) { similarProduct in
                                            NavigationLink(destination: ProductDetailView(product: similarProduct)) {
                                                SimilarProductCard(product: similarProduct)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Yorumlar bölümü
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Yorumlar")
                                    .font(.title3.bold())
                                if !viewModel.reviews.isEmpty {
                                    HStack(spacing: 4) {
                                        ForEach(1...5, id: \.self) { index in
                                            Image(systemName: index <= Int(viewModel.averageRating.rounded()) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.caption)
                                        }
                                        Text(String(format: "%.1f", viewModel.averageRating))
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button("Yorum Yap") {
                                showAddReview = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        if viewModel.reviews.isEmpty {
                            Text("Henüz yorum yapılmamış")
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                        } else {
                            ForEach(viewModel.reviews) { review in
                                ProductReviewView(review: review)
                            }
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showAddReview) {
                        AddReviewView(viewModel: viewModel, product: product)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CartButton()
                        .background(GeometryReader { geometry in
                            Color.clear.preference(
                                key: ViewPositionKey.self,
                                value: geometry.frame(in: .global).center
                            )
                        })
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AddToCartButton(viewModel: viewModel, product: product) {
                showAddedToCartAlert = true
            }
        }
        .fullScreenCover(isPresented: $showFullScreenImage) {
            FullScreenImageView(imageData: product.imageData)
        }
        .alert("Sepete Eklendi", isPresented: $showAddedToCartAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("\(product.name) sepete eklendi.")
        }
        .addToCartAnimation(
            from: productImagePosition,
            to: cartButtonPosition,
            isAnimating: $isAddToCartAnimating
        )
        .onPreferenceChange(ViewPositionKey.self) { position in
            cartButtonPosition = position
        }
    }
    
    private func shareProduct() {
        let text = """
        \(product.name)
        \(product.description)
        Fiyat: \(localizationManager.formatPrice(product.price))
        """
        let av = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        // iPad için popover presentation
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            av.popoverPresentationController?.sourceView = rootVC.view
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 0, height: 0)
            av.popoverPresentationController?.permittedArrowDirections = []
            rootVC.present(av, animated: true)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .bold()
        }
    }
}

struct FullScreenImageView: View {
    let imageData: Data?
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var currentRotation: Angle = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(scale)
                        .offset(offset)
                        .rotationEffect(currentRotation)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        scale = 1.0
                                        offset = .zero
                                    }
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                        )
                        .gesture(
                            RotationGesture()
                                .onChanged { angle in
                                    currentRotation = angle
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        currentRotation = .zero
                                    }
                                }
                        )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct AddToCartButton: View {
    @ObservedObject var viewModel: ProductDetailViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var cartManager: CartManager
    let product: Product
    var onAdd: (() -> Void)?
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            HStack {
                // Miktar seçici
                Stepper("\(localizationManager.strings.quantity): \(viewModel.quantity)", 
                        value: $viewModel.quantity, in: 1...10)
                    .fixedSize()
                
                Spacer()
                
                // Sepete ekle butonu
                Button {
                    // Haptic feedback
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    // Buton animasyonu
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                    
                    // Sepete ekleme
                    viewModel.addToCart(product)
                    onAdd?()
                    
                    // Animasyonu resetle
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPressed = false
                    }
                } label: {
                    Text(localizationManager.strings.addToCart)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 44)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .shadow(radius: 2)
        }
    }
}

// Varyant butonu
struct VariantButton: View {
    let variant: ProductVariant
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(variant.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: variant.icon)
                            .foregroundColor(variant.color)
                    )
                    .overlay(
                        Circle()
                            .stroke(isSelected ? variant.color : Color.clear, lineWidth: 2)
                    )
                
                Text(variant.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
        }
    }
}

// Ürün varyantları için enum
enum ProductVariant: CaseIterable {
    case original, mint, berry, citrus
    
    var name: String {
        switch self {
        case .original: return "Original"
        case .mint: return "Nane"
        case .berry: return "Berry Mix"
        case .citrus: return "Citrus"
        }
    }
    
    var color: Color {
        switch self {
        case .original: return .blue
        case .mint: return .green
        case .berry: return .purple
        case .citrus: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .original: return "leaf.fill"
        case .mint: return "leaf.arrow.circlepath"
        case .berry: return "sparkles"
        case .citrus: return "sun.max.fill"
        }
    }
}

// Pozisyon takibi için PreferenceKey
struct ViewPositionKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
} 
