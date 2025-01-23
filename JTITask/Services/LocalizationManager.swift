import Foundation

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .turkish
    
    var strings: any LocalizedStrings {
        switch currentLanguage {
        case .turkish:
            return TurkishStrings()
        case .english:
            return EnglishStrings()
        case .swedish:
            return SwedishStrings()
        }
    }
    
    var currencySymbol: String {
        switch currentLanguage {
        case .turkish: return "₺"
        case .english: return "$"
        case .swedish: return "€"
        }
    }
    
    var currencyRate: Double {
        switch currentLanguage {
        case .turkish: return 1.0
        case .english: return 0.035 // 1 TL = 0.035 USD
        case .swedish: return 0.032 // 1 TL = 0.032 EUR
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        let convertedPrice = price * currencyRate
        return "\(currencySymbol)\(String(format: "%.2f", convertedPrice))"
    }
}

enum Language: String {
    case turkish = "tr"
    case english = "en"
    case swedish = "sv"
}

protocol LocalizedStrings {
    var menu: String { get }
    var profile: String { get }
    var home: String { get }
    var products: String { get }
    var cart: String { get }
    var languageSelection: String { get }
    var checkout: String { get }
    var emptyCart: String { get }
    var startShopping: String { get }
    var total: String { get }
    var addToCart: String { get }
    var quantity: String { get }
}

struct TurkishStrings: LocalizedStrings {
    let menu = "Menü"
    let profile = "Profil"
    let home = "Ana Sayfa"
    let products = "Ürünler"
    let cart = "Sepet"
    let languageSelection = "Dil Seçimi"
    let checkout = "Ödemeye Geç"
    let emptyCart = "Sepetiniz boş"
    let startShopping = "Ürün eklemek için alışverişe başlayın"
    let total = "Toplam"
    let addToCart = "Sepete Ekle"
    let quantity = "Adet"
}

struct EnglishStrings: LocalizedStrings {
    let menu = "Menu"
    let profile = "Profile"
    let home = "Home"
    let products = "Products"
    let cart = "Cart"
    let languageSelection = "Language Selection"
    let checkout = "Checkout"
    let emptyCart = "Your cart is empty"
    let startShopping = "Start shopping to add products"
    let total = "Total"
    let addToCart = "Add to Cart"
    let quantity = "Quantity"
}

struct SwedishStrings: LocalizedStrings {
    let menu = "Meny"
    let profile = "Profil"
    let home = "Hem"
    let products = "Produkter"
    let cart = "Vagn"
    let languageSelection = "Välj språk"
    let checkout = "Till kassan"
    let emptyCart = "Din vagn är tom"
    let startShopping = "Börja handla för att lägga till produkter"
    let total = "Totalt"
    let addToCart = "Lägg i varukorgen"
    let quantity = "Antal"
} 