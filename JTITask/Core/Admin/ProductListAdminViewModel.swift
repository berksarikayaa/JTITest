import Foundation
import CoreData

class ProductListAdminViewModel: ObservableObject {
    @Published var products: [NSManagedObject] = []
    private let coreDataManager = CoreDataManager.shared
    
    func loadProducts() {
        products = coreDataManager.getAllProducts()
    }
    
    func deleteProducts(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = products[index]
            coreDataManager.deleteProduct(product)
        }
        loadProducts()
    }
} 