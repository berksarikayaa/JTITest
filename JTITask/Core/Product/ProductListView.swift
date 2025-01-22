import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { oldValue, newValue in
                    viewModel.searchProducts()
                }
            
            // Kategori filtreleme
            ScrollView(.horizontal, showsIndicators: false) {
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
            
            // Ürün listesi
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(viewModel.searchText.isEmpty ? viewModel.products : viewModel.filteredProducts) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(localizationManager.strings.products)
        .background(Color(colorScheme == .dark ? .black : .white).ignoresSafeArea())
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