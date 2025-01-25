import SwiftUI
import PhotosUI
import CoreData
import os

final class AdminPanelViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productDescription = ""
    @Published var price = ""
    @Published var nicotineStrength = ""
    @Published var quantity = ""
    @Published var selectedCategory: ProductCategory = .original
    @Published var selectedImage: Image?
    @Published var selectedUIImage: UIImage? {
        didSet {
            if let image = selectedUIImage {
                selectedImage = Image(uiImage: image)
                selectedImageData = image.jpegData(compressionQuality: 0.8)
            }
        }
    }
    @Published var selectedImageData: Data?
    @Published var showSuccessAlert = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let coreDataManager: CoreDataManager
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AdminPanel")
    private var editingProduct: NSManagedObject?
    
    var isEditing: Bool { editingProduct != nil }
    
    var isFormValid: Bool {
        !productName.isEmpty &&
        !productDescription.isEmpty &&
        !price.isEmpty &&
        !nicotineStrength.isEmpty &&
        !quantity.isEmpty &&
        selectedImageData != nil &&
        Double(price) != nil &&
        Int(quantity) != nil
    }
    
    init(coreDataManager: CoreDataManager = .shared, editingProduct: NSManagedObject? = nil) {
        self.coreDataManager = coreDataManager
        self.editingProduct = editingProduct
        
        if let product = editingProduct {
            loadProductData(product)
        }
    }
    
    private func loadProductData(_ product: NSManagedObject) {
        productName = product.value(forKey: "name") as? String ?? ""
        productDescription = product.value(forKey: "desc") as? String ?? ""
        if let price = product.value(forKey: "price") as? Double {
            self.price = String(format: "%.2f", price)
        }
        nicotineStrength = product.value(forKey: "nicotineStrength") as? String ?? ""
        if let quantity = product.value(forKey: "quantity") as? Int16 {
            self.quantity = String(quantity)
        }
        if let category = product.value(forKey: "category") as? String,
           let categoryEnum = ProductCategory(rawValue: category) {
            selectedCategory = categoryEnum
        }
        if let imageData = product.value(forKey: "imageData") as? Data,
           let uiImage = UIImage(data: imageData) {
            selectedImageData = imageData
            selectedUIImage = uiImage
        }
    }
    
    func saveProduct() {
        // Fiyatı nokta ile ayır ve boşlukları temizle
        let formattedPrice = price.replacingOccurrences(of: ",", with: ".")
                                 .trimmingCharacters(in: .whitespaces)
        
        guard let priceDouble = Double(formattedPrice),
              let quantityInt = Int(quantity) else {
            showError = true
            errorMessage = "Lütfen tüm alanları doğru formatta doldurun."
            return
        }
        
        if let product = editingProduct {
            // Güncelleme
            coreDataManager.updateProduct(
                product,
                name: productName,
                description: productDescription,
                price: priceDouble,
                nicotineStrength: nicotineStrength,
                quantity: quantityInt,
                category: selectedCategory,
                imageData: selectedImageData
            )
        } else {
            // Yeni ürün ekleme
            guard let imageData = selectedImageData else {
                showError = true
                errorMessage = "Lütfen bir ürün görseli seçin."
                return
            }
            
            coreDataManager.saveProduct(
                name: productName,
                description: productDescription,
                price: priceDouble,
                nicotineStrength: nicotineStrength,
                quantity: quantityInt,
                category: selectedCategory,
                imageData: imageData
            )
        }
        
        resetForm()
        showSuccessAlert = true
    }
    
    private func resetForm() {
        productName = ""
        productDescription = ""
        price = ""
        nicotineStrength = ""
        quantity = ""
        selectedCategory = .original
        selectedImage = nil
        selectedUIImage = nil
        selectedImageData = nil
    }
} 