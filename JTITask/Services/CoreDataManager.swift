import CoreData
import SwiftUI
import os

/// Core Data işlemlerini yöneten singleton sınıf
final class CoreDataManager {
    static let shared = CoreDataManager()
    static let didSaveProductNotification = Notification.Name("didSaveProduct")
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "CoreData")
    private let container: NSPersistentContainer
    
    /// Core Data view context'ini döndürür
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "ProductModel")
        
        // SQLite dosyasının konumunu belirle
        if let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ProductModel.sqlite") {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [storeDescription]
            
            logger.notice("Core Data store URL: \(storeURL.path)")
        }
        
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                self?.logger.error("Core Data yüklenirken hata: \(error.localizedDescription)")
                self?.resetStore()
            } else {
                self?.logger.notice("Core Data başarıyla yüklendi")
            }
        }
        
        // Performance optimizasyonları
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    /// Veritabanını sıfırlar
    private func resetStore() {
        let coordinator = container.persistentStoreCoordinator
        
        // Tüm store'ları sil
        for store in coordinator.persistentStores {
            do {
                try coordinator.remove(store)
            } catch {
                logger.error("Store kaldırılırken hata: \(error.localizedDescription)")
            }
        }
        
        // Documents klasöründeki SQLite dosyalarını sil
        if let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let sqliteFiles = ["ProductModel.sqlite", "ProductModel.sqlite-shm", "ProductModel.sqlite-wal"]
            
            for file in sqliteFiles {
                let fileURL = storeURL.appendingPathComponent(file)
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
        
        // Yeni store oluştur
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: nil, options: nil)
            logger.notice("Veritabanı başarıyla sıfırlandı")
        } catch {
            logger.error("Yeni store oluşturulurken hata: \(error.localizedDescription)")
        }
    }
    
    /// Tüm ürünleri getirir
    /// - Returns: NSManagedObject dizisi
    func getAllProducts() -> [NSManagedObject] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        
        // Performans için batch size ayarla
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            logger.error("Ürünler yüklenirken hata: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveProduct(name: String, description: String, price: Double, 
                    nicotineStrength: String, quantity: Int, 
                    category: ProductCategory, imageData: Data) {
        let context = container.viewContext
        let product = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: context)
        
        let productId = UUID().uuidString
        
        product.setValue(productId, forKey: "id")
        product.setValue(name, forKey: "name")
        product.setValue(description, forKey: "desc")
        product.setValue(price, forKey: "price")
        product.setValue(nicotineStrength, forKey: "nicotineStrength")
        product.setValue(Int16(quantity), forKey: "quantity")
        product.setValue(category.rawValue, forKey: "category")
        product.setValue(imageData, forKey: "imageData")
        product.setValue(Date(), forKey: "createdAt")
        product.setValue(false, forKey: "isFavorite")
        
        do {
            try context.save()
            logger.notice("Ürün başarıyla kaydedildi: \(name)")
            NotificationCenter.default.post(name: CoreDataManager.didSaveProductNotification, object: nil)
        } catch {
            logger.error("Ürün kaydedilirken hata: \(error.localizedDescription)")
            context.rollback()
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
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.error("Veri kaydedilirken hata: \(error.localizedDescription)")
                // Hata durumunda context'i sıfırla
                context.rollback()
            }
        }
    }
    
    /// Örnek ürünleri veritabanına ekler
    func seedProducts() {
        // Veritabanı boşsa örnek ürünleri ekle
        let count = try? container.viewContext.count(for: NSFetchRequest(entityName: "ProductEntity"))
        guard count == 0 else { return }
        
        // Örnek ürün görselleri
        let images = ["nordic1", "nordic2", "nordic3", "original1", "original2", "smooth1"]
        
        // Örnek ürünler
        let products = [
            (name: "Nordic Spirit Original", 
             description: "Güçlü ve otantik bir deneyim sunan Nordic Spirit Original, geleneksel İskandinav tadını modern bir yorumla sunuyor.",
             price: 149.99,
             category: ProductCategory.nordic,
             nicotineStrength: "14mg/g",
             quantity: 20),
            
            (name: "Original Strong", 
             description: "Klasik ve güçlü bir tat arayanlar için ideal seçim. Yoğun aroması ile tatmin edici bir deneyim sunar.",
             price: 129.99,
             category: ProductCategory.original,
             nicotineStrength: "16mg/g",
             quantity: 15),
            
            (name: "Smooth Mint", 
             description: "Ferahlatıcı nane aroması ile gün boyu tazelik hissi. Hafif ve dengeli içim deneyimi sunar.",
             price: 139.99,
             category: ProductCategory.smooth,
             nicotineStrength: "12mg/g",
             quantity: 25)
        ]
        
        // Ürünleri kaydet
        for (index, product) in products.enumerated() {
            if let image = UIImage(named: images[index]),
               let imageData = image.jpegData(compressionQuality: 0.8) {
                saveProduct(
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    nicotineStrength: product.nicotineStrength,
                    quantity: product.quantity,
                    category: product.category,
                    imageData: imageData
                )
            }
        }
        
        logger.notice("Örnek ürünler başarıyla eklendi")
    }
    
    func toggleFavorite(for productId: String, completion: @escaping (Bool) -> Void) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            if let product = try context.fetch(fetchRequest).first {
                let currentValue = product.value(forKey: "isFavorite") as? Bool ?? false
                let newValue = !currentValue
                product.setValue(newValue, forKey: "isFavorite")
                try context.save()
                
                // Tüm view'ları güncelle
                NotificationCenter.default.post(
                    name: CoreDataManager.didSaveProductNotification,
                    object: nil,
                    userInfo: ["productId": productId]
                )
                
                completion(newValue)
            }
        } catch {
            logger.error("Favori güncellenirken hata: \(error.localizedDescription)")
            context.rollback()
            completion(false)
        }
    }
} 