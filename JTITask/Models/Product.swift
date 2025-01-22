struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let category: ProductCategory
    let nicotineStrength: String
    let quantity: Int
}

enum ProductCategory: String, Codable, CaseIterable {
    case original = "Original"
    case nordic = "Nordic"
    case smooth = "Smooth"
} 