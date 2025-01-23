import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Kış indirimi banner'ı
            Image("winter-banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
            // Arama çubuğu
            SearchBar(text: $searchText)
                .onChange(of: searchText) { _, newValue in
                    viewModel.searchProducts(query: newValue)
                }
                .padding(.vertical, 4)
            
            ScrollView {
                VStack(spacing: 8) {
                    // Nordic Spirit banner'ı
                    Image("nordic-banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // Kategoriler
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kategoriler")
                            .font(.title2.bold())
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                CategoryCard(category: nil, isSelected: viewModel.selectedCategory == nil) {
                                    viewModel.filterByCategory(nil)
                                }
                                
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    CategoryCard(
                                        category: category,
                                        isSelected: viewModel.selectedCategory == category
                                    ) {
                                        viewModel.filterByCategory(category)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Öne çıkan ürünler
                    VStack(alignment: .leading) {
                        Text("Öne Çıkan Ürünler")
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(searchText.isEmpty ? viewModel.filteredProducts : viewModel.filteredProducts, id: \.self) { product in
                                NavigationLink {
                                    if let name = product.value(forKey: "name") as? String,
                                       let desc = product.value(forKey: "desc") as? String,
                                       let price = product.value(forKey: "price") as? Double,
                                       let nicotineStrength = product.value(forKey: "nicotineStrength") as? String,
                                       let quantity = product.value(forKey: "quantity") as? Int16,
                                       let category = product.value(forKey: "category") as? String,
                                       let categoryEnum = ProductCategory(rawValue: category) {
                                        let mappedProduct = Product(
                                            id: product.value(forKey: "id") as? String ?? UUID().uuidString,
                                            name: name,
                                            description: desc,
                                            price: price,
                                            imageName: "", // Core Data'dan gelen ürünler için boş bırakıyoruz
                                            category: categoryEnum,
                                            nicotineStrength: nicotineStrength,
                                            quantity: Int(quantity)
                                        )
                                        ProductDetailView(product: mappedProduct)
                                    }
                                } label: {
                                    ProductCard(managedProduct: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color(colorScheme == .dark ? .black : .white))
        .onAppear {
            // Notification'ı dinle
            NotificationCenter.default.addObserver(
                forName: CoreDataManager.didSaveProductNotification,
                object: nil,
                queue: .main) { _ in
                    viewModel.refreshProducts()
                }
        }
    }
}
