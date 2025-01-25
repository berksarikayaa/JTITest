import Foundation
import CoreData
import os
import UIKit

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Favorites")
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
        loadFavorites()
        
        // Favori değişikliklerini dinle
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProductUpdate),
            name: CoreDataManager.didSaveProductNotification,
            object: nil
        )
    }
    
    @objc func handleProductUpdate() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        let managedObjects = coreDataManager.getAllProducts()
        favoriteProducts = managedObjects
            .compactMap { Product(managedObject: $0) }
            .filter { $0.isFavorite }
    }
    
    func toggleFavorite(_ product: inout Product) {
        product.isFavorite.toggle()
        
        // Core Data'yı güncelle
        do {
            if let managedObject = coreDataManager.getAllProducts().first(where: { $0.value(forKey: "id") as? String == product.id }) {
                managedObject.setValue(product.isFavorite, forKey: "isFavorite")
                try coreDataManager.viewContext.save()
                loadFavorites()
                
                // Haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } catch {
            logger.error("Favori güncellenirken hata: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(_ product: Product) {
        do {
            if let managedObject = coreDataManager.getAllProducts().first(where: { $0.value(forKey: "id") as? String == product.id }) {
                managedObject.setValue(false, forKey: "isFavorite")
                try coreDataManager.viewContext.save()
                loadFavorites()
                
                // Haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } catch {
            logger.error("Favori silinirken hata: \(error.localizedDescription)")
        }
    }
} 