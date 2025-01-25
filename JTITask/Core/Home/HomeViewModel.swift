import Foundation
import CoreData

final class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var selectedCategory: ProductCategory?
    @Published var searchText: String = ""
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
        loadProducts()
        
        // Favori değişikliklerini dinle
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProductUpdate),
            name: CoreDataManager.didSaveProductNotification,
            object: nil
        )
    }
    
    @objc func handleProductUpdate() {
        loadProducts()
    }
    
    private func loadProducts() {
        let managedObjects = coreDataManager.getAllProducts()
        products = managedObjects.compactMap { Product(managedObject: $0) }
        filterProducts()
    }
    
    func searchProducts(query: String) {
        searchText = query
        filterProducts()
    }
    
    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = selectedCategory == nil ? products : products.filter {
                $0.category == selectedCategory
            }
        } else {
            filteredProducts = products.filter { product in
                let name = product.name.lowercased()
                let description = product.description.lowercased()
                
                return (name.contains(searchText.lowercased()) ||
                       description.contains(searchText.lowercased())) &&
                       (selectedCategory == nil || product.category == selectedCategory)
            }
        }
    }
    
    func filterByCategory(_ category: ProductCategory?) {
        selectedCategory = category
        filterProducts()
    }
} 