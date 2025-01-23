import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    static let didSaveProductNotification = Notification.Name("didSaveProduct")
    
    init() {
        container = NSPersistentContainer(name: "ProductModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data yüklenirken hata: \(error.localizedDescription)")
            }
        }
    }
    
    func saveProduct(name: String, description: String, price: Double, 
                    nicotineStrength: String, quantity: Int, 
                    category: ProductCategory, imageData: Data) {
        let context = container.viewContext
        let product = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: context)
        
        product.setValue(UUID().uuidString, forKey: "id")
        product.setValue(name, forKey: "name")
        product.setValue(description, forKey: "desc")
        product.setValue(price, forKey: "price")
        product.setValue(nicotineStrength, forKey: "nicotineStrength")
        product.setValue(Int16(quantity), forKey: "quantity")
        product.setValue(category.rawValue, forKey: "category")
        product.setValue(imageData, forKey: "imageData")
        product.setValue(Date(), forKey: "createdAt")
        
        save()
        NotificationCenter.default.post(name: CoreDataManager.didSaveProductNotification, object: nil)
    }
    
    func getAllProducts() -> [NSManagedObject] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ürünler yüklenirken hata: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteProduct(_ product: NSManagedObject) {
        container.viewContext.delete(product)
        save()
    }
    
    func updateProduct(_ product: NSManagedObject, 
                      name: String, 
                      description: String, 
                      price: Double,
                      nicotineStrength: String, 
                      quantity: Int, 
                      category: ProductCategory, 
                      imageData: Data?) {
        
        product.setValue(name, forKey: "name")
        product.setValue(description, forKey: "desc")
        product.setValue(price, forKey: "price")
        product.setValue(nicotineStrength, forKey: "nicotineStrength")
        product.setValue(Int16(quantity), forKey: "quantity")
        product.setValue(category.rawValue, forKey: "category")
        
        if let imageData = imageData {
            product.setValue(imageData, forKey: "imageData")
        }
        
        save()
        NotificationCenter.default.post(name: CoreDataManager.didSaveProductNotification, object: nil)
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Veri kaydedilirken hata: \(error.localizedDescription)")
        }
    }
} 