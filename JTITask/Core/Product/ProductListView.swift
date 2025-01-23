import SwiftUI
import CoreData

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            // Arama çubuğu
            SearchBar(text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.searchProducts()
                }
            
            // Kategori filtreleme
            ScrollView(.horizontal, showsIndicators: false) {
                categoryFilterView
            }
            
            // Ürün listesi
            ScrollView {
                productGridView
            }
        }
        .navigationTitle(localizationManager.strings.products)
        .background(Color(colorScheme == .dark ? .black : .white).ignoresSafeArea())
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
    
    private var productGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(viewModel.filteredProducts, id: \.self) { managedProduct in
                NavigationLink {
                    if let name = managedProduct.value(forKey: "name") as? String,
                       let desc = managedProduct.value(forKey: "desc") as? String,
                       let price = managedProduct.value(forKey: "price") as? Double,
                       let nicotineStrength = managedProduct.value(forKey: "nicotineStrength") as? String,
                       let quantity = managedProduct.value(forKey: "quantity") as? Int16,
                       let category = managedProduct.value(forKey: "category") as? String,
                       let categoryEnum = ProductCategory(rawValue: category) {
                        let product = Product(
                            id: managedProduct.value(forKey: "id") as? String ?? UUID().uuidString,
                            name: name,
                            description: desc,
                            price: price,
                            imageName: "", // Core Data'dan gelen ürünler için boş bırakıyoruz
                            category: categoryEnum,
                            nicotineStrength: nicotineStrength,
                            quantity: Int(quantity)
                        )
                        ProductDetailView(product: product)
                    }
                } label: {
                    ProductCard(managedProduct: managedProduct)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
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