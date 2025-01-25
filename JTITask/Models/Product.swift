import CoreData
import UIKit // UIImage için eklendi

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: ProductCategory
    let nicotineStrength: String
    let quantity: Int
    let imageData: Data?
    var images360: [UIImage]? // 360 derece görüntüler için eklendi
    var videoURL: URL? // Video URL'i için eklendi
    var isFavorite: Bool = false // Favori özelliği eklendi
    
    // Core Data'dan ürün oluştururken kullanılacak init
    init(managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey: "id") as? String ?? UUID().uuidString
        self.name = managedObject.value(forKey: "name") as? String ?? ""
        self.description = managedObject.value(forKey: "desc") as? String ?? ""
        self.price = managedObject.value(forKey: "price") as? Double ?? 0.0
        self.imageName = ""
        self.category = ProductCategory(rawValue: managedObject.value(forKey: "category") as? String ?? "") ?? .original
        self.nicotineStrength = managedObject.value(forKey: "nicotineStrength") as? String ?? ""
        self.quantity = Int(managedObject.value(forKey: "quantity") as? Int16 ?? 0)
        self.imageData = managedObject.value(forKey: "imageData") as? Data
        self.images360 = nil
        self.videoURL = nil
    }
    
    // Normal init
    init(id: String, name: String, description: String, price: Double, imageName: String, category: ProductCategory, nicotineStrength: String, quantity: Int, imageData: Data?) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageName = imageName
        self.category = category
        self.nicotineStrength = nicotineStrength
        self.quantity = quantity
        self.imageData = imageData
        self.images360 = nil
        self.videoURL = nil
    }
    
    // Hashable için gerekli fonksiyonlar
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

enum ProductCategory: String, Codable, CaseIterable {
    case original = "Original"
    case nordic = "Nordic"
    case smooth = "Smooth"
} 