import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    @Published var featuredProducts: [NSManagedObject] = []
    @Published var filteredProducts: [NSManagedObject] = []
    @Published var selectedCategory: ProductCategory?
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadFeaturedProducts()
    }
    
    private func loadFeaturedProducts() {
        featuredProducts = coreDataManager.getAllProducts()
        filteredProducts = featuredProducts
    }
    
    func searchProducts(query: String) {
        if query.isEmpty {
            filteredProducts = selectedCategory == nil ? featuredProducts : featuredProducts.filter {
                $0.value(forKey: "category") as? String == selectedCategory?.rawValue
            }
        } else {
            let filtered = featuredProducts.filter { product in
                let name = product.value(forKey: "name") as? String ?? ""
                let description = product.value(forKey: "desc") as? String ?? ""
                let category = product.value(forKey: "category") as? String
                
                return (name.lowercased().contains(query.lowercased()) ||
                       description.lowercased().contains(query.lowercased())) &&
                       (selectedCategory == nil || category == selectedCategory?.rawValue)
            }
            filteredProducts = filtered
        }
    }
    
    func filterByCategory(_ category: ProductCategory?) {
        selectedCategory = category
        if let category = category {
            filteredProducts = featuredProducts.filter {
                $0.value(forKey: "category") as? String == category.rawValue
            }
        } else {
            filteredProducts = featuredProducts
        }
    }
    
    // Ürün eklendiğinde veya silindiğinde listeyi yenile
    func refreshProducts() {
        loadFeaturedProducts()
    }
} 