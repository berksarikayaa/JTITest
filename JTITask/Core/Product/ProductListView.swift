import SwiftUI
import CoreData

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    // Arama çubuğu
                    SearchBar(text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.searchProducts(query: newValue)
                        }
                    
                    // Kategori filtreleme
                    ScrollView(.horizontal, showsIndicators: false) {
                        categoryFilterView
                    }
                    
                    // Ürün listesi
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
                .navigationTitle(localizationManager.strings.products)
            }
        }
    }
    
    private var categoryFilterView: some View {
        HStack(spacing: 12) {
            ForEach(ProductCategory.allCases, id: \.self) { category in
                CategoryFilterButton(
                    category: category,
                    isSelected: viewModel.selectedCategory == category,
                    action: { viewModel.filterProducts(by: category) }
                )
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

struct CategoryFilterButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
} 
