import Foundation
import CoreData

class ProductListViewModel: ObservableObject {
    @Published var products: [NSManagedObject] = []
    @Published var filteredProducts: [NSManagedObject] = []
    @Published var isLoading = false
    @Published var selectedCategory: ProductCategory?
    @Published var searchText = ""
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts(category: ProductCategory? = nil) {
        isLoading = true
        products = coreDataManager.getAllProducts()
        filterProducts()
        isLoading = false
    }
    
    func filterProducts(by category: ProductCategory? = nil) {
        selectedCategory = category
        filterProducts()
    }
    
    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = selectedCategory == nil ? products : products.filter {
                $0.value(forKey: "category") as? String == selectedCategory?.rawValue
            }
        } else {
            let filtered = products.filter { product in
                let name = product.value(forKey: "name") as? String ?? ""
                let description = product.value(forKey: "desc") as? String ?? ""
                let category = product.value(forKey: "category") as? String
                
                return (name.lowercased().contains(searchText.lowercased()) ||
                       description.lowercased().contains(searchText.lowercased())) &&
                       (selectedCategory == nil || category == selectedCategory?.rawValue)
            }
            filteredProducts = filtered
        }
    }
    
    func searchProducts() {
        filterProducts()
    }
} 