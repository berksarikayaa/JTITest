import SwiftUI
import PhotosUI
import CoreData

class AdminPanelViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productDescription = ""
    @Published var price = ""
    @Published var nicotineStrength = ""
    @Published var quantity = ""
    @Published var selectedCategory: ProductCategory = .original
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: Image?
    @Published var selectedImageData: Data?
    @Published var showSuccessAlert = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let coreDataManager = CoreDataManager.shared
    private var editingProduct: NSManagedObject?
    
    var isEditing: Bool { editingProduct != nil }
    
    init(editingProduct: NSManagedObject? = nil) {
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
            selectedImage = Image(uiImage: uiImage)
        }
    }
    
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
    
    func loadImage() {
        guard let item = selectedItem else { return }
        
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
                
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.selectedImageData = data
                        self.selectedImage = Image(uiImage: uiImage)
                    }
                }
            } catch {
                await MainActor.run {
                    self.showError = true
                    self.errorMessage = "Görsel yüklenirken hata oluştu"
                }
                print("Görsel yüklenirken hata: \(error.localizedDescription)")
            }
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
        selectedItem = nil
        selectedImage = nil
        selectedImageData = nil
    }
} 