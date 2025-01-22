import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .onChange(of: searchText) { _, newValue in
                    viewModel.searchProducts(query: newValue)
                }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Banner
                    Image("nordic-banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    // Kategoriler
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(ProductCategory.allCases, id: \.self) { category in
                                CategoryCard(category: category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Öne çıkan ürünler
                    Text("Öne Çıkan Ürünler")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Ürün grid görünümü
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(searchText.isEmpty ? viewModel.featuredProducts : viewModel.filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Nordic Spirit")
        }
    }
} 