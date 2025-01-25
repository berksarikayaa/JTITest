import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @State private var offset: CGFloat = 0
    
    // Gradient renklerini güncelleyelim
    private let gradientColors: [Color] = [
        Color(hex: "134E5E"),  // Koyu deniz mavisi
        Color(hex: "71B280"),  // Yumuşak yeşil
        Color(hex: "2193b0"),  // Parlak mavi
        Color(hex: "6dd5ed")   // Açık mavi
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Banner bölümü
                        bannerSection
                        
                        // Arama çubuğu
                        searchSection
                        
                        // Ürün listesi
                        productGridSection
                    }
                }
            }
            .navigationTitle("Ana Sayfa")
            .onAppear {
                // Notification'ı dinle
                NotificationCenter.default.addObserver(
                    forName: CoreDataManager.didSaveProductNotification,
                    object: nil,
                    queue: .main) { _ in
                        viewModel.refreshProducts()
                    }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                self.offset = offset
            }
        }
    }
    
    // Banner bölümü
    private var bannerSection: some View {
        VStack {
            Image("winter-banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
            Image("nordic-banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
    
    // Arama bölümü
    private var searchSection: some View {
        SearchBar(text: $searchText)
            .onChange(of: searchText) { newValue in
                viewModel.searchProducts(query: newValue)
            }
            .padding(.vertical, 4)
    }
    
    // Ürün grid bölümü
    private var productGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(viewModel.filteredProducts, id: \.self) { managedProduct in
                if let product = createProduct(from: managedProduct) {
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        ProductCard(product: product)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Helper fonksiyon: NSManagedObject'ten Product oluşturma
    private func createProduct(from managedProduct: NSManagedObject) -> Product? {
        guard let name = managedProduct.value(forKey: "name") as? String,
              let desc = managedProduct.value(forKey: "desc") as? String,
              let price = managedProduct.value(forKey: "price") as? Double,
              let nicotineStrength = managedProduct.value(forKey: "nicotineStrength") as? String,
              let quantity = managedProduct.value(forKey: "quantity") as? Int16,
              let category = managedProduct.value(forKey: "category") as? String,
              let imageData = managedProduct.value(forKey: "imageData") as? Data,
              let categoryEnum = ProductCategory(rawValue: category) else {
            return nil
        }
        
        return Product(
            id: managedProduct.value(forKey: "id") as? String ?? UUID().uuidString,
            name: name,
            description: desc,
            price: price,
            imageName: "",
            category: categoryEnum,
            nicotineStrength: nicotineStrength,
            quantity: Int(quantity),
            imageData: imageData
        )
    }
}

// Hex renk kodu için extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Scroll offset'i takip etmek için
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ScrollView için ViewModifier
struct ScrollOffsetModifier: ViewModifier {
    let coordinateSpace: String
    
    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { proxy in
                let offset = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: offset
                )
            }
        )
    }
}
